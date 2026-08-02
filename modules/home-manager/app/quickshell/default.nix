{ theme, helpers }:
{
  xdg.configFile."quickshell/config.json".text =
    theme.overrides.quickshell or (import ./template.nix { colors = theme.colors; });
}
