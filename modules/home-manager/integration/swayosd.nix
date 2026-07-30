{ theme, helpers }:
{
  xdg.configFile."swayosd/style.css".text =
    theme.overrides.swayosd or (import ../templates/swayosd.nix { colors = theme.colors; inherit helpers; });
}
