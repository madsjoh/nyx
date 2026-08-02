{ theme, helpers }:
{
  xdg.configFile."foot/foot.ini".text =
    theme.overrides.foot or (import ./template.nix { colors = theme.colors; inherit helpers; });
}
