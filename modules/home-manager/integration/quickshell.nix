{ theme, helpers }:
{
  xdg.configFile."quickshell/config.json".text =
    theme.overrides.quickshell or (import ../templates/quickshell.nix { colors = theme.colors; });
}
