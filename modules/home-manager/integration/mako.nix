{ theme, helpers }:
{
  xdg.configFile."mako/config".text =
    theme.overrides.mako or (import ../templates/mako.nix { colors = theme.colors; inherit helpers; });
}
