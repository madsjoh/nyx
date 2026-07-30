{ theme, helpers }:
{
  xdg.configFile."hypr/hyprland.lua".text =
    theme.overrides.hyprland or (import ../templates/hyprland.nix { colors = theme.colors; inherit helpers; });
}
