{ theme, helpers }:

let
  hyprDir = ../hyprland;
  rf = name: builtins.readFile (hyprDir + ("/" + name));

  themeOverride = theme.overrides.hyprland or
    (import ../templates/hyprland.nix { colors = theme.colors; inherit helpers; });
in
{
  xdg.configFile = {
    "hypr/hyprland.lua".text = ''
      package.path = os.getenv("HOME")
        .. "/.config/?.lua;"
        .. package.path

      require("hypr.nyx.loader")
      require("hypr.monitors")
      require("hypr.nyx.toggles")
    '';

    "hypr/nyx/loader.lua".text = rf "loader.lua";
    "hypr/nyx/paths.lua".text = rf "paths.lua";
    "hypr/nyx/helpers.lua".text = rf "helpers.lua";
    "hypr/nyx/require_all.lua".text = rf "require_all.lua";
    "hypr/nyx/envs.lua".text = rf "envs.lua";
    "hypr/nyx/looknfeel.lua".text = rf "looknfeel.lua";
    "hypr/nyx/input.lua".text = rf "input.lua";
    "hypr/nyx/autostart.lua".text = rf "autostart.lua";
    "hypr/nyx/windows.lua".text = rf "windows.lua";
    "hypr/nyx/apps.lua".text = rf "apps.lua";
    "hypr/nyx/bindings.lua".text = rf "bindings.lua";
    "hypr/nyx/plain-bindings.lua".text = rf "plain-bindings.lua";
    "hypr/nyx/toggles.lua".text = rf "toggles/toggles.lua";

    "hypr/nyx/bindings/clipboard.lua".text = rf "bindings/clipboard.lua";
    "hypr/nyx/bindings/media.lua".text = rf "bindings/media.lua";
    "hypr/nyx/bindings/tiling-v2.lua".text = rf "bindings/tiling-v2.lua";
    "hypr/nyx/bindings/utilities.lua".text = rf "bindings/utilities.lua";

    "hypr/nyx/toggles/flags.lua".text = rf "toggles/flags.lua";
    "hypr/nyx/toggles/rounded-corners.conf".text = rf "toggles/rounded-corners.conf";
    "hypr/nyx/toggles/single-window-aspect-ratio.lua".text = rf "toggles/single-window-aspect-ratio.lua";
    "hypr/nyx/toggles/window-no-gaps.lua".text = rf "toggles/window-no-gaps.lua";

    "hypr/nyx/apps/1password.lua".text = rf "apps/1password.lua";
    "hypr/nyx/apps/bitwarden.lua".text = rf "apps/bitwarden.lua";
    "hypr/nyx/apps/browser.lua".text = rf "apps/browser.lua";
    "hypr/nyx/apps/davinci-resolve.lua".text = rf "apps/davinci-resolve.lua";
    "hypr/nyx/apps/geforce.lua".text = rf "apps/geforce.lua";
    "hypr/nyx/apps/hyprshot.lua".text = rf "apps/hyprshot.lua";
    "hypr/nyx/apps/jetbrains.lua".text = rf "apps/jetbrains.lua";
    "hypr/nyx/apps/localsend.lua".text = rf "apps/localsend.lua";
    "hypr/nyx/apps/moonlight.lua".text = rf "apps/moonlight.lua";
    "hypr/nyx/apps/pip.lua".text = rf "apps/pip.lua";
    "hypr/nyx/apps/qemu.lua".text = rf "apps/qemu.lua";
    "hypr/nyx/apps/retroarch.lua".text = rf "apps/retroarch.lua";
    "hypr/nyx/apps/steam.lua".text = rf "apps/steam.lua";
    "hypr/nyx/apps/system.lua".text = rf "apps/system.lua";
    "hypr/nyx/apps/telegram.lua".text = rf "apps/telegram.lua";
    "hypr/nyx/apps/terminals.lua".text = rf "apps/terminals.lua";
    "hypr/nyx/apps/typora.lua".text = rf "apps/typora.lua";
    "hypr/nyx/apps/walker.lua".text = rf "apps/walker.lua";
    "hypr/nyx/apps/webcam-overlay.lua".text = rf "apps/webcam-overlay.lua";

    "hypr/monitors.lua".text = rf "config-monitors.lua";
    "hypr/hypridle.conf".text = rf "hypridle.conf";
    "hypr/hyprsunset.conf".text = rf "hyprsunset.conf";
    "hypr/xdph.conf".text = rf "xdph.conf";
    "hypr/.luarc.json".text = rf ".luarc.json";

    "nyx/current/hyprland.lua".text = themeOverride;
    "nyx/scripts/cycle-background.sh".text = rf "cycle-background.sh";
  };
}
