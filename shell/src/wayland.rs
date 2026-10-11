use std::cell::RefCell;
use std::num::NonZeroU32;
use std::rc::Rc;
use std::time::Duration;

use calloop::timer::{TimeoutAction, Timer};
use calloop::EventLoop;
use calloop_wayland_source::WaylandSource;

use smithay_client_toolkit::compositor::{CompositorHandler, CompositorState};
use smithay_client_toolkit::delegate_registry;
use smithay_client_toolkit::output::{OutputHandler, OutputState};
use smithay_client_toolkit::registry::{ProvidesRegistryState, RegistryState};
use smithay_client_toolkit::registry_handlers;
use smithay_client_toolkit::seat::keyboard::{KeyEvent, KeyboardHandler, Keysym};
use smithay_client_toolkit::seat::pointer::{PointerEvent, PointerEventKind, PointerHandler};
use smithay_client_toolkit::seat::{Capability, SeatHandler, SeatState};
use smithay_client_toolkit::shell::wlr_layer::{
    Anchor, KeyboardInteractivity, Layer, LayerShell, LayerShellHandler, LayerSurface,
    LayerSurfaceConfigure, SurfaceKind,
};
use smithay_client_toolkit::shell::WaylandSurface;
use smithay_client_toolkit::shm::slot::SlotPool;
use smithay_client_toolkit::shm::{Shm, ShmHandler};
use wayland_client::protocol::{wl_keyboard, wl_output, wl_pointer, wl_seat, wl_shm, wl_surface};
use wayland_client::{Connection, QueueHandle};

use slint::platform::software_renderer::PremultipliedRgbaColor;
use slint::{ModelRc, SharedString};

use crate::launcher::{self, Commands};
use crate::platform::{LayerWindowAdapter, SharedState};
use crate::ui::{BarWindow, LauncherWindow};

struct Surface {
    layer: LayerSurface,
    pool: Option<SlotPool>,
    width: u32,
    height: u32,
    mapped: bool,
}

pub struct App {
    registry_state: RegistryState,
    seat_state: SeatState,
    output_state: OutputState,
    shm: Shm,
    compositor: CompositorState,
    layer_shell: LayerShell,

    surfaces: Vec<Surface>,
    shared: Rc<SharedState>,
    bar: Option<BarWindow>,
    last_clock: String,
    exit: bool,

    launcher: Option<LauncherWindow>,
    launcher_surface: usize,
    apps: Vec<launcher::App>,
    launcher_query: String,
    launcher_selected: usize,
    launcher_visible: bool,
    launcher_mapped: bool,
    commands: Rc<RefCell<Commands>>,
    workspaces_rx: Option<std::sync::mpsc::Receiver<String>>,

    keyboard: Option<wl_keyboard::WlKeyboard>,
    pointer: Option<wl_pointer::WlPointer>,
}

impl App {
    pub fn new(
        globals: &wayland_client::globals::GlobalList,
        qh: &QueueHandle<Self>,
        shared: Rc<SharedState>,
    ) -> Result<Self, Box<dyn std::error::Error>> {
        let compositor = CompositorState::bind(globals, qh).expect("wl_compositor is not available");
        let layer_shell = LayerShell::bind(globals, qh).expect("layer shell is not available");
        let shm = Shm::bind(globals, qh).expect("wl_shm is not available");

        Ok(Self {
            registry_state: RegistryState::new(globals),
            seat_state: SeatState::new(globals, qh),
            output_state: OutputState::new(globals, qh),
            shm,
            compositor,
            layer_shell,
            surfaces: Vec::new(),
            shared,
            bar: None,
            last_clock: String::new(),
            exit: false,
            launcher: None,
            launcher_surface: 0,
            apps: Vec::new(),
            launcher_query: String::new(),
            launcher_selected: 0,
            launcher_visible: false,
            launcher_mapped: false,
            commands: Rc::new(RefCell::new(Commands::default())),
            workspaces_rx: None,
            keyboard: None,
            pointer: None,
        })
    }

    /// Create a top bar layer surface anchored to the top, left, and right edges.
    pub fn add_bar_surface(&mut self, qh: &QueueHandle<Self>, height: u32) {
        let surface = self.compositor.create_surface(qh);
        let layer = self
            .layer_shell
            .create_layer_surface(qh, surface, Layer::Top, Some("nyx-shell-bar"), None);
        layer.set_anchor(Anchor::TOP | Anchor::LEFT | Anchor::RIGHT);
        layer.set_exclusive_zone(height as i32);
        layer.set_keyboard_interactivity(KeyboardInteractivity::None);
        layer.set_size(0, height);
        layer.commit();

        self.surfaces.push(Surface {
            layer,
            pool: None,
            width: 0,
            height,
            mapped: true,
        });
    }

    /// Create a centered overlay surface used by the launcher and panels.
    pub fn add_overlay_surface(
        &mut self,
        qh: &QueueHandle<Self>,
        namespace: &str,
        width: u32,
        height: u32,
    ) {
        let surface = self.compositor.create_surface(qh);
        let layer = self.layer_shell.create_layer_surface(
            qh,
            surface,
            Layer::Overlay,
            Some(namespace),
            None,
        );
        layer.set_anchor(Anchor::TOP | Anchor::LEFT | Anchor::RIGHT);
        layer.set_keyboard_interactivity(KeyboardInteractivity::OnDemand);
        layer.set_size(width, height);
        layer.commit();

        self.surfaces.push(Surface {
            layer,
            pool: None,
            width,
            height,
            mapped: false,
        });
    }

    pub fn surface_count(&self) -> usize {
        self.surfaces.len()
    }

    pub fn surface_dims(&self, index: usize) -> (u32, u32) {
        self.surfaces
            .get(index)
            .map(|s| (s.width, s.height))
            .unwrap_or((0, 0))
    }

    fn allocate_pools(&mut self) {
        for surface in &mut self.surfaces {
            if surface.width == 0 || surface.height == 0 {
                continue;
            }
            let bytes = (surface.width * surface.height * 4 * 2) as usize;
            if surface.pool.is_none() {
                surface.pool = Some(SlotPool::new(bytes.max(1), &self.shm).expect("create pool"));
            }
        }
    }

    fn render_dirty(&mut self) {
        self.allocate_pools();

        let adapters: Vec<Rc<LayerWindowAdapter>> = self.shared.adapters.borrow().clone();
        for adapter in adapters {
            let surface_id = match *adapter.surface_id.borrow() {
                Some(id) => id,
                None => continue,
            };
            let Some(surface) = self.surfaces.get_mut(surface_id) else {
                continue;
            };
            if !surface.mapped {
                continue;
            }

            let (width, height) = (surface.width, surface.height);
            if width == 0 || height == 0 {
                continue;
            }
            let stride = (width * 4) as i32;
            let Some(pool) = surface.pool.as_mut() else {
                continue;
            };

            let Ok((buffer, canvas)) =
                pool.create_buffer(width as i32, height as i32, stride, wl_shm::Format::Argb8888)
            else {
                continue;
            };

            let drawn = adapter.msw.draw_if_needed(|renderer| {
                let mut scratch =
                    vec![
                        PremultipliedRgbaColor { red: 0, green: 0, blue: 0, alpha: 0 };
                        (width * height) as usize
                    ];
                renderer.render(scratch.as_mut_slice(), width as usize);
                for (pixel, chunk) in scratch.iter().zip(canvas.chunks_exact_mut(4)) {
                    chunk[0] = pixel.blue;
                    chunk[1] = pixel.green;
                    chunk[2] = pixel.red;
                    chunk[3] = pixel.alpha;
                }
            });

            if drawn {
                surface
                    .layer
                    .wl_surface()
                    .damage_buffer(0, 0, width as i32, height as i32);
                buffer
                    .attach_to(surface.layer.wl_surface())
                    .expect("attach buffer");
                surface.layer.commit();
            }
        }
    }

    pub fn set_bar(&mut self, bar: BarWindow) {
        self.bar = Some(bar);
    }

    pub fn set_launcher(&mut self, launcher: LauncherWindow, surface: usize, apps: Vec<launcher::App>) {
        self.launcher = Some(launcher);
        self.launcher_surface = surface;
        self.apps = apps;
    }

    pub fn commands(&self) -> Rc<RefCell<Commands>> {
        self.commands.clone()
    }

    pub fn set_workspaces_rx(&mut self, rx: Option<std::sync::mpsc::Receiver<String>>) {
        self.workspaces_rx = rx;
    }

    fn map_surface(&mut self, id: usize) {
        if let Some(surface) = self.surfaces.get_mut(id) {
            surface.mapped = true;
        }
    }

    fn unmap_surface(&mut self, id: usize) {
        if let Some(surface) = self.surfaces.get_mut(id) {
            surface.mapped = false;
            surface.layer.attach(None, 0, 0);
            surface.layer.commit();
        }
    }

    fn show_launcher(&mut self) {
        self.launcher_query.clear();
        self.launcher_selected = 0;
        self.launcher_visible = true;
        self.map_surface(self.launcher_surface);
        self.update_launcher_results();
    }

    fn hide_launcher(&mut self) {
        self.launcher_visible = false;
        self.unmap_surface(self.launcher_surface);
    }

    fn activate_launcher(&mut self) {
        let apps = launcher::search(&self.apps, &self.launcher_query);
        if let Some(app) = apps.get(self.launcher_selected).copied() {
            launcher::launch(app);
        }
        self.hide_launcher();
    }

    fn update_launcher_results(&mut self) {
        let Some(launcher) = &self.launcher else {
            return;
        };
        let results = launcher::search(&self.apps, &self.launcher_query);
        let names: Vec<SharedString> = results
            .iter()
            .map(|app| SharedString::from(app.name.as_str()))
            .collect();
        launcher.set_results(ModelRc::from(names.as_slice()));
        launcher.set_query(SharedString::from(self.launcher_query.as_str()));
        launcher.set_selected(self.launcher_selected as i32);
    }

    fn handle_launcher_key(&mut self, event: KeyEvent) {
        match event.keysym {
            Keysym::Escape => self.hide_launcher(),
            Keysym::Return | Keysym::KP_Enter => self.activate_launcher(),
            Keysym::Up => {
                self.launcher_selected = self.launcher_selected.saturating_sub(1);
                self.update_launcher_results();
            }
            Keysym::Down => {
                self.launcher_selected += 1;
                self.update_launcher_results();
            }
            Keysym::BackSpace => {
                self.launcher_query.pop();
                self.launcher_selected = 0;
                self.update_launcher_results();
            }
            _ => {
                if let Some(text) = &event.utf8 {
                    if !text.chars().any(char::is_control) {
                        self.launcher_query.push_str(text);
                        self.launcher_selected = 0;
                        self.update_launcher_results();
                    }
                }
            }
        }
    }

    fn refresh_launcher_visibility(&mut self) {
        if self.launcher_visible && !self.launcher_mapped {
            self.launcher_mapped = true;
            self.map_surface(self.launcher_surface);
        } else if !self.launcher_visible && self.launcher_mapped {
            self.launcher_mapped = false;
            self.unmap_surface(self.launcher_surface);
        }
    }

    fn tick(&mut self) {
        if let Some(bar) = &self.bar {
            let text = chrono::Local::now().format("%A %H:%M").to_string();
            if text != self.last_clock {
                self.last_clock = text.clone();
                bar.set_clock(text.into());
            }
        }

        if let Some(rx) = &self.workspaces_rx {
            while let Ok(text) = rx.try_recv() {
                if let Some(bar) = &self.bar {
                    bar.set_workspaces(text.into());
                }
            }
        }

        let commands = std::mem::replace(&mut *self.commands.borrow_mut(), Commands::default());
        if commands.show_launcher {
            self.show_launcher();
        }
        if let Some(index) = commands.activate {
            self.launcher_selected = index;
            self.activate_launcher();
        }

        self.refresh_launcher_visibility();
        self.render_dirty();
    }

    pub fn run(
        mut self,
        conn: Connection,
        event_queue: wayland_client::EventQueue<Self>,
    ) -> Result<(), Box<dyn std::error::Error>> {
        let mut event_loop: EventLoop<Self> = EventLoop::try_new()?;
        let handle = event_loop.handle();

        WaylandSource::new(conn.clone(), event_queue).insert(handle.clone())?;

        let timer = Timer::from_duration(Duration::from_millis(33));
        handle.insert_source(timer, |_event, _meta, state: &mut Self| {
            state.tick();
            TimeoutAction::ToDuration(Duration::from_millis(33))
        })?;

        event_loop.run(None, &mut self, |_| {})?;
        Ok(())
    }
}

impl CompositorHandler for App {
    fn scale_factor_changed(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _new_factor: i32,
    ) {
    }

    fn transform_changed(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _new_transform: wl_output::Transform,
    ) {
    }

    fn frame(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _time: u32,
    ) {
    }

    fn surface_enter(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _output: &wl_output::WlOutput,
    ) {
    }

    fn surface_leave(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _surface: &wl_surface::WlSurface,
        _output: &wl_output::WlOutput,
    ) {
    }
}

impl OutputHandler for App {
    fn output_state(&mut self) -> &mut OutputState {
        &mut self.output_state
    }

    fn new_output(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _output: wl_output::WlOutput) {}

    fn update_output(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _output: wl_output::WlOutput) {}

    fn output_destroyed(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _output: wl_output::WlOutput) {}
}

impl LayerShellHandler for App {
    fn closed(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _layer: &LayerSurface) {
        self.exit = true;
    }

    fn configure(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        layer: &LayerSurface,
        configure: LayerSurfaceConfigure,
        serial: u32,
    ) {
        if let SurfaceKind::Wlr(wlr) = layer.kind() {
            wlr.ack_configure(serial);
        }

        for surface in &mut self.surfaces {
            if &surface.layer == layer {
                surface.width =
                    NonZeroU32::new(configure.new_size.0).map_or(0, NonZeroU32::get);
                let configured_height =
                    NonZeroU32::new(configure.new_size.1).map_or(surface.height, NonZeroU32::get);
                if configured_height != 0 {
                    surface.height = configured_height;
                }
            }
        }
    }
}

impl SeatHandler for App {
    fn seat_state(&mut self) -> &mut SeatState {
        &mut self.seat_state
    }

    fn new_seat(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _seat: wl_seat::WlSeat) {}

    fn new_capability(
        &mut self,
        _conn: &Connection,
        qh: &QueueHandle<Self>,
        seat: wl_seat::WlSeat,
        capability: Capability,
    ) {
        if capability == Capability::Keyboard && self.keyboard.is_none() {
            self.keyboard =
                self.seat_state.get_keyboard(qh, &seat, None).ok();
        }
        if capability == Capability::Pointer && self.pointer.is_none() {
            self.pointer = self.seat_state.get_pointer(qh, &seat).ok();
        }
    }

    fn remove_capability(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _seat: wl_seat::WlSeat,
        capability: Capability,
    ) {
        if capability == Capability::Keyboard && self.keyboard.is_some() {
            self.keyboard.take().unwrap().release();
        }
        if capability == Capability::Pointer && self.pointer.is_some() {
            self.pointer.take().unwrap().release();
        }
    }

    fn remove_seat(&mut self, _conn: &Connection, _qh: &QueueHandle<Self>, _seat: wl_seat::WlSeat) {}
}

impl KeyboardHandler for App {
    fn enter(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _keyboard: &wl_keyboard::WlKeyboard,
        _surface: &wl_surface::WlSurface,
        _serial: u32,
        _raw: &[u32],
        _keysyms: &[Keysym],
    ) {
    }

    fn leave(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _keyboard: &wl_keyboard::WlKeyboard,
        _surface: &wl_surface::WlSurface,
        _serial: u32,
    ) {
    }

    fn press_key(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _keyboard: &wl_keyboard::WlKeyboard,
        _serial: u32,
        event: KeyEvent,
    ) {
        if self.launcher_visible {
            self.handle_launcher_key(event);
        }
    }

    fn repeat_key(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _keyboard: &wl_keyboard::WlKeyboard,
        _serial: u32,
        _event: KeyEvent,
    ) {
    }

    fn release_key(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _keyboard: &wl_keyboard::WlKeyboard,
        _serial: u32,
        _event: KeyEvent,
    ) {
    }

    fn update_modifiers(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _keyboard: &wl_keyboard::WlKeyboard,
        _serial: u32,
        _modifiers: smithay_client_toolkit::seat::keyboard::Modifiers,
        _raw_modifiers: smithay_client_toolkit::seat::keyboard::RawModifiers,
        _layout: u32,
    ) {
    }
}

impl PointerHandler for App {
    fn pointer_frame(
        &mut self,
        _conn: &Connection,
        _qh: &QueueHandle<Self>,
        _pointer: &wl_pointer::WlPointer,
        events: &[PointerEvent],
    ) {
        for event in events {
            if let PointerEventKind::Press { button, .. } = event.kind {
                log::debug!("press {:x}", button);
            }
        }
    }
}

impl ShmHandler for App {
    fn shm_state(&mut self) -> &mut Shm {
        &mut self.shm
    }
}

delegate_registry!(App);

impl ProvidesRegistryState for App {
    fn registry(&mut self) -> &mut RegistryState {
        &mut self.registry_state
    }
    registry_handlers![OutputState, SeatState];
}

smithay_client_toolkit::delegate_dispatch2!(App);
