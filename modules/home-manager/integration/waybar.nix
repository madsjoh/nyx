{ theme, helpers }:
{
  xdg.configFile."waybar/nyx-theme.css".text =
    theme.overrides.waybar or (import ../templates/waybar.nix { colors = theme.colors; inherit helpers; });
}
