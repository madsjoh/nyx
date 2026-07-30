{ theme, helpers }:
{
  xdg.configFile."kitty/nyx-theme.conf".text =
    theme.overrides.kitty or (import ../templates/kitty.nix { colors = theme.colors; inherit helpers; });
}
