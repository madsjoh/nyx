{ lib, themes }:

let
  themeNames = builtins.attrNames themes;
  appNames = [
    "alacritty"    "btop"    "chromium"    "foot"    "ghostty"    "gum"    "helix"    "hyprland"    "hyprlock"    "keyboard-rgb"    "kitty"    "mako"    "obsidian"    "quickshell"    "starship"    "swayosd"    "walker"    "waybar"
  ];
  mkAppOption = name: {
    ${name} = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Nyx theming for ${name}";
      };
    };
  };
in
{
  options.nyx = {
    autostart = {
      hideRedundantApplets = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Hide redundant tray applets such as nm-applet, blueman, and fcitx5";
      };
    };

    enable = lib.mkEnableOption "Nyx theme module";

    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "XKB keyboard layout";
      };
      model = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "XKB keyboard model";
      };
      options = lib.mkOption {
        type = lib.types.str;
        default = "compose:caps";
        description = "XKB keyboard options";
      };
      rules = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "XKB keyboard rules";
      };
      variant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "XKB keyboard variant";
      };
    };

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "tokyo-night";
      description = "Active Nyx theme";
    };
  } // lib.foldl' (acc: name: acc // mkAppOption name) {} appNames;
}
