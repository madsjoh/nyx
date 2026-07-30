{ theme, helpers }:
{
  xdg.configFile."walker/config.css".text =
    theme.overrides.walker or (import ../templates/walker.nix { colors = theme.colors; inherit helpers; });
}
