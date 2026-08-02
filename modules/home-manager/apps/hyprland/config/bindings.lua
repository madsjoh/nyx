-- Default key bindings.
require("hypr.nyx.bindings.media")
require("hypr.nyx.bindings.clipboard")
require("hypr.nyx.bindings.tiling-v2")
require("hypr.nyx.bindings.utilities")

-- Application bindings.
o.bind("SUPER + RETURN", "Terminal", { launch = "alacritty" })
o.bind("SUPER + SHIFT + RETURN", "Browser", { launch = "chromium" })
o.bind("SUPER + SHIFT + F", "File manager", { launch = "nautilus" })
o.bind("SUPER + SHIFT + B", "Browser", { launch = "chromium" })
o.bind("SUPER + SHIFT + N", "Editor", { launch = "gnome-text-editor" })
