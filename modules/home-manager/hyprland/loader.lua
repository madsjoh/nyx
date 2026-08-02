-- Nyx Hyprland setup: helpers, defaults, and current theme overrides.

require("hypr.nyx.helpers")

-- Use Nyx defaults, but don't edit these directly.
require("hypr.nyx.autostart")
require("hypr.nyx.bindings")
require("hypr.nyx.envs")
require("hypr.nyx.looknfeel")
require("hypr.nyx.input")
require("hypr.nyx.windows")

-- Current theme overrides (deployed via xdg.configFile to ~/.config/nyx/current/).
do
  local paths = require("hypr.nyx.paths")
  local theme_file = paths.config_home .. "/nyx/current/hyprland.lua"
  local theme = io.open(theme_file, "r")
  if theme then
    theme:close()
    dofile(theme_file)
  end
end
