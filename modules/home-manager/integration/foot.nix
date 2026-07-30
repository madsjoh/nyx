{ theme, helpers }:
{
  xdg.configFile."foot/foot.ini".text =
    theme.overrides.foot or (import ../templates/foot.nix { colors = theme.colors; inherit helpers; });
}
