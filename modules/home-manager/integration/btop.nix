{ theme, helpers }:
{
  xdg.configFile."btop/themes/nyx.theme".text =
    theme.overrides.btop or (import ../templates/btop.nix { colors = theme.colors; inherit helpers; });
}
