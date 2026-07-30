{ lib, themes }:

let
  themeNames = builtins.attrNames themes;
  appNames = [
    "alacritty"    "btop"    "chromium"    "foot"    "ghostty"    "gum"    "helix"    "hyprland"    "hyprlock"    "keyboard-rgb"    "kitty"    "mako"    "obsidian"    "quickshell"    "swayosd"    "walker"    "waybar"
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
    enable = lib.mkEnableOption "Nyx theme module";

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "gruvbox";
      description = "Active Nyx theme";
    };
  } // lib.foldl' (acc: name: acc // mkAppOption name) {} appNames;
}
