{ theme, helpers }:
{
  xdg.configFile."nyx/keyboard.rgb".text =
    theme.overrides."keyboard-rgb" or (import ./template.nix { colors = theme.colors; });
}
