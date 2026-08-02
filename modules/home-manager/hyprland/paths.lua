-- Shared path constants for Nyx's Hyprland Lua modules.

local home = os.getenv("HOME")

return {
  home = home,
  config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config"),
  state_home = os.getenv("XDG_STATE_HOME") or (home .. "/.local/state"),
  nyx_path = os.getenv("NYX_PATH") or (home .. "/.config/nyx"),
}
