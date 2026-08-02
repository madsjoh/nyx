{ theme, helpers }:
{
  xdg.configFile."hypr/hyprlock.conf".text =
    theme.overrides.hyprlock or (import ./template.nix { colors = theme.colors; inherit helpers; });
}
