{ theme, helpers }:
{
  xdg.configFile."kitty/kitty.conf".text =
    theme.overrides.kitty or (import ./template.nix { colors = theme.colors; });
}
