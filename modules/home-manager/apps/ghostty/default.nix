{ theme, helpers }:
{
  xdg.configFile."ghostty/config".text =
    theme.overrides.ghostty or (import ./template.nix { colors = theme.colors; });
}
