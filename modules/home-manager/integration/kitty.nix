{ theme, helpers }:
{
  xdg.configFile."kitty/kitty.conf".text =
    theme.overrides.kitty or (import ../templates/kitty.nix { colors = theme.colors; });
}
