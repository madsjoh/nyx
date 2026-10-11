use std::rc::Rc;

use wayland_client::globals::registry_queue_init;

use slint::ComponentHandle;

mod config;
mod hyprland;
mod launcher;
mod panels;
mod platform;
mod status;
mod ui;
mod wayland;

use panels::PanelKind;
use ui::{
    AudioWindow, BarWindow, ClockWindow, LauncherWindow, NetworkWindow, NyxTheme, PowerWindow,
    WeatherWindow,
};

fn apply_theme(bar: &BarWindow, config: &config::Config) {
    let theme = bar.global::<NyxTheme>();
    let c = |hex: &str| config.color(hex);
    theme.set_accent(c(&config.colors.accent));
    theme.set_background(c(&config.colors.background));
    theme.set_foreground(c(&config.colors.foreground));
    theme.set_surface(c(&config.colors.background));
    theme.set_cursor(c(&config.colors.cursor));
    theme.set_color0(c(&config.colors.color0));
    theme.set_color1(c(&config.colors.color1));
    theme.set_color2(c(&config.colors.color2));
    theme.set_color3(c(&config.colors.color3));
    theme.set_color4(c(&config.colors.color4));
    theme.set_color5(c(&config.colors.color5));
    theme.set_color6(c(&config.colors.color6));
    theme.set_color7(c(&config.colors.color7));
    theme.set_color8(c(&config.colors.color8));
    theme.set_color9(c(&config.colors.color9));
    theme.set_color10(c(&config.colors.color10));
    theme.set_color11(c(&config.colors.color11));
    theme.set_color12(c(&config.colors.color12));
    theme.set_color13(c(&config.colors.color13));
    theme.set_color14(c(&config.colors.color14));
    theme.set_color15(c(&config.colors.color15));
    theme.invoke_apply();
}

fn apply_bar_layout(bar: &BarWindow, config: &config::Config) {
    bar.set_corner_radius(config.bar.corner_radius as f32);
    bar.set_spacing(config.bar.spacing as f32);
    bar.set_text_size(config.bar.text_size as f32);
    bar.set_font_family(config.bar.font_family.clone().into());
    bar.set_logo(config.bar.logo.clone().into());
}

fn apply_launcher_layout(launcher: &LauncherWindow, config: &config::Config) {
    launcher.set_corner_radius(config.launcher.corner_radius as f32);
    launcher.set_text_size(config.launcher.text_size as f32);
    launcher.set_font_family(config.bar.font_family.clone().into());
}

fn panel_font(config: &config::Config) -> slint::SharedString {
    config.bar.font_family.clone().into()
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    let config = config::Config::load();

    let conn = wayland_client::Connection::connect_to_env()?;
    let (globals, mut event_queue) = registry_queue_init(&conn)?;
    let qh = event_queue.handle();

    let shared = platform::SharedState::new();
    let mut app = wayland::App::new(&globals, &qh, shared.clone())?;

    app.add_bar_surface(&qh, config.bar.height.max(1) as u32);
    app.add_overlay_surface(&qh, "nyx-shell-launcher", 640, 420);
    app.add_overlay_surface(&qh, "nyx-shell-clock", 320, 360);
    app.add_overlay_surface(&qh, "nyx-shell-weather", 360, 280);
    app.add_overlay_surface(&qh, "nyx-shell-network", 360, 320);
    app.add_overlay_surface(&qh, "nyx-shell-audio", 320, 160);
    app.add_overlay_surface(&qh, "nyx-shell-power", 320, 340);

    event_queue.roundtrip(&mut app)?;

    for i in 0..app.surface_count() {
        shared.pending_surfaces.borrow_mut().push_back(i);
    }

    slint::platform::set_platform(Box::new(platform::NyxPlatform { shared: shared.clone() }))
        .expect("set platform");

    let bar = BarWindow::new()?;
    let launcher = LauncherWindow::new()?;
    let clock = ClockWindow::new()?;
    let weather = WeatherWindow::new()?;
    let network = NetworkWindow::new()?;
    let audio = AudioWindow::new()?;
    let power = PowerWindow::new()?;

    apply_theme(&bar, &config);
    apply_bar_layout(&bar, &config);
    apply_launcher_layout(&launcher, &config);

    let font = panel_font(&config);
    let panel_radius = config.panel.corner_radius as f32;
    let panel_text = config.panel.text_size as f32;
    clock.set_corner_radius(panel_radius);
    clock.set_text_size(panel_text);
    clock.set_font_family(font.clone());
    weather.set_corner_radius(panel_radius);
    weather.set_text_size(panel_text);
    weather.set_font_family(font.clone());
    network.set_corner_radius(panel_radius);
    network.set_text_size(panel_text);
    network.set_font_family(font.clone());
    audio.set_corner_radius(panel_radius);
    audio.set_text_size(panel_text);
    audio.set_font_family(font.clone());
    power.set_corner_radius(panel_radius);
    power.set_text_size(panel_text);
    power.set_font_family(font.clone());

    for adapter in shared.adapters.borrow().iter() {
        if let Some(id) = *adapter.surface_id.borrow() {
            let (width, height) = app.surface_dims(id);
            adapter.set_physical_size(width, height);
        }
        adapter.msw.request_redraw();
    }

    let commands = app.commands();

    let show = Rc::clone(&commands);
    bar.on_launch(move || {
        show.borrow_mut().show_launcher = true;
    });
    let activate = Rc::clone(&commands);
    launcher.on_activate(move |index| {
        activate.borrow_mut().activate = Some(index as usize);
    });

    let cmd = Rc::clone(&commands);
    bar.on_open_clock(move || {
        cmd.borrow_mut().toggle_panel = Some(PanelKind::Clock);
    });
    let cmd = Rc::clone(&commands);
    bar.on_open_weather(move || {
        cmd.borrow_mut().toggle_panel = Some(PanelKind::Weather);
    });
    let cmd = Rc::clone(&commands);
    bar.on_open_network(move || {
        cmd.borrow_mut().toggle_panel = Some(PanelKind::Network);
    });
    let cmd = Rc::clone(&commands);
    bar.on_open_audio(move || {
        cmd.borrow_mut().toggle_panel = Some(PanelKind::Audio);
    });
    let cmd = Rc::clone(&commands);
    bar.on_open_power(move || {
        cmd.borrow_mut().toggle_panel = Some(PanelKind::Power);
    });

    let cmd = Rc::clone(&commands);
    power.on_action(move |action| {
        cmd.borrow_mut().power_action = Some(action.to_string());
    });
    let cmd = Rc::clone(&commands);
    audio.on_set_volume(move |volume| {
        cmd.borrow_mut().audio_volume = Some(volume);
    });
    let cmd = Rc::clone(&commands);
    audio.on_toggle_mute(move || {
        cmd.borrow_mut().audio_toggle_mute = true;
    });
    let cmd = Rc::clone(&commands);
    network.on_connect(move |index| {
        cmd.borrow_mut().network_connect = Some(index as usize);
    });

    let apps = launcher::load_apps();
    app.set_bar(bar);
    app.set_launcher(launcher, apps);
    app.set_panels(clock, weather, network, audio, power);

    let workspaces_rx = spawn_workspaces();
    app.set_workspaces_rx(workspaces_rx);

    app.set_status_rx(spawn_status());

    app.run(conn, event_queue)?;
    Ok(())
}

fn spawn_workspaces() -> Option<std::sync::mpsc::Receiver<String>> {
    let hypr = hyprland::Hyprland::connect()?;
    let (tx, rx) = std::sync::mpsc::channel::<String>();
    std::thread::spawn(move || {
        let mut last = String::new();
        loop {
            if let Some((ids, active)) = hypr.workspaces() {
                let text = hyprland::format_workspaces(&ids, active);
                if text != last {
                    let _ = tx.send(text.clone());
                    last = text;
                }
            }
            std::thread::sleep(std::time::Duration::from_millis(1000));
        }
    });
    Some(rx)
}

fn spawn_status() -> Option<std::sync::mpsc::Receiver<status::Status>> {
    let (tx, rx) = std::sync::mpsc::channel::<status::Status>();
    std::thread::spawn(move || {
        let mut poller = status::StatusPoller::new();
        loop {
            let snapshot = poller.poll();
            let _ = tx.send(snapshot);
            std::thread::sleep(std::time::Duration::from_millis(2000));
        }
    });
    Some(rx)
}
