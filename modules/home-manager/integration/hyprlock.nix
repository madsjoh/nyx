{ theme, helpers }:
{
  xdg.configFile."hypr/hyprlock.conf".text =
    theme.overrides.hyprlock or (import ../templates/hyprlock.nix { colors = theme.colors; inherit helpers; });
}
