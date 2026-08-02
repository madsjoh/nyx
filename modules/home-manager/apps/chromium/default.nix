{ theme, helpers }:
let
  chromiumPolicy = theme.overrides.chromium or (import ./template.nix { colors = theme.colors; inherit helpers; });
in
{
  xdg.configFile."nyx/chromium.theme".text = chromiumPolicy;

  xdg.configFile."chromium-flags.conf".text = ''
    --ozone-platform=wayland
    --ozone-platform-hint=wayland
    --enable-features=TouchpadOverscrollHistoryNavigation
  '';

  home.file.".config/chromium/policies/managed/nyx-color.json".text = chromiumPolicy;
}
