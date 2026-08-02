-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors all

local nyx_gdk_scale = 2
local nyx_monitor_scale = "auto"

-- Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
-- local nyx_gdk_scale = 2
-- local nyx_monitor_scale = "auto"

-- Good compromise for 27" or 32" 4K monitors (but fractional!): monitor scale 1.6, GDK scale 1.75.
-- local nyx_gdk_scale = 1.75
-- local nyx_monitor_scale = 1.6

-- Straight 1x setup for low-resolution displays like 1080p, 1440p, or ultrawides: both 1.
-- local nyx_gdk_scale = 1
-- local nyx_monitor_scale = 1

hl.env("GDK_SCALE", tostring(nyx_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = nyx_monitor_scale })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°)
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Disable a specific monitor.
-- hl.monitor({ output = "DP-2", disabled = true })
