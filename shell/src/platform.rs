use std::cell::RefCell;
use std::rc::Rc;

use slint::platform::software_renderer::{MinimalSoftwareWindow, RepaintBufferType};
use slint::platform::{Platform, WindowAdapter};
use slint::{PhysicalSize, PlatformError, Window, WindowSize};

/// Shared state between the Slint platform and the Wayland event loop.
pub struct SharedState {
    pub adapters: RefCell<Vec<Rc<LayerWindowAdapter>>>,
    /// Surface indices handed out to adapters in creation order.
    pub pending_surfaces: RefCell<std::collections::VecDeque<usize>>,
}

impl SharedState {
    pub fn new() -> Rc<Self> {
        Rc::new(Self {
            adapters: RefCell::new(Vec::new()),
            pending_surfaces: RefCell::new(std::collections::VecDeque::new()),
        })
    }
}

/// A Slint window adapter bound to one Wayland layer surface.
pub struct LayerWindowAdapter {
    pub msw: Rc<MinimalSoftwareWindow>,
    pub surface_id: RefCell<Option<usize>>,
}

impl LayerWindowAdapter {
    pub fn set_physical_size(&self, width: u32, height: u32) {
        self.msw.set_size(WindowSize::Physical(PhysicalSize::new(width, height)));
    }
}

impl WindowAdapter for LayerWindowAdapter {
    fn window(&self) -> &Window {
        self.msw.window()
    }

    fn size(&self) -> PhysicalSize {
        self.msw.size()
    }

    fn renderer(&self) -> &dyn slint::platform::Renderer {
        self.msw.renderer()
    }

    fn set_size(&self, size: WindowSize) {
        self.msw.set_size(size);
    }

    fn request_redraw(&self) {
        self.msw.request_redraw();
    }
}

/// The Slint platform. Each `create_window_adapter` call consumes the next
/// pending surface index and binds a fresh adapter to it.
pub struct NyxPlatform {
    pub shared: Rc<SharedState>,
}

impl Platform for NyxPlatform {
    fn create_window_adapter(&self) -> Result<Rc<dyn WindowAdapter>, PlatformError> {
        let surface_id = self.shared.pending_surfaces.borrow_mut().pop_front();
        let adapter = Rc::new(LayerWindowAdapter {
            msw: MinimalSoftwareWindow::new(RepaintBufferType::NewBuffer),
            surface_id: RefCell::new(surface_id),
        });
        self.shared.adapters.borrow_mut().push(adapter.clone());
        Ok(adapter)
    }
}
