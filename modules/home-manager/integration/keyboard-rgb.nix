{ theme, helpers }:
{
  xdg.configFile."nyx/keyboard.rgb".text =
    theme.overrides."keyboard-rgb" or (import ../templates/keyboard-rgb.nix { colors = theme.colors; });
}
