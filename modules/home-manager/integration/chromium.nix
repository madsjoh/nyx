{ theme, helpers }:
{
  xdg.configFile."nyx/chromium.theme".text =
    theme.overrides.chromium or (import ../templates/chromium.nix { colors = theme.colors; inherit helpers; });
}
