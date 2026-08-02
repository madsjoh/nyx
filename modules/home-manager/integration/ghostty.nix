{ theme, helpers }:
{
  xdg.configFile."ghostty/config".text =
    theme.overrides.ghostty or (import ../templates/ghostty.nix { colors = theme.colors; });
}
