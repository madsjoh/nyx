{ lib, themes }:

let
  themeNames = builtins.attrNames themes;
  appNames = [
    "alacritty" "btop" "chromium" "foot" "ghostty" "gum" "helix" "hyprland"
    "hyprlock" "keyboard-rgb" "kitty" "mako" "obsidian" "shell"
    "starship" "swayosd"
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
  options.nyx = lib.recursiveUpdate
    (
      {
        enable = lib.mkEnableOption "Nyx theme module";

        theme = lib.mkOption {
          type = lib.types.enum themeNames;
          default = "tokyo-night";
          description = "Active Nyx theme";
        };
      } // lib.foldl' (acc: name: acc // mkAppOption name) { } appNames
    )
    {
      shell = {
        barHeight = lib.mkOption {
          type = lib.types.int;
          default = 26;
          description = "Height of the nyx-shell top bar in pixels.";
        };
        cornerRadius = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "Corner radius of shell surfaces in pixels.";
        };
        spacing = lib.mkOption {
          type = lib.types.int;
          default = 8;
          description = "Spacing between bar widgets in pixels.";
        };
        textSize = lib.mkOption {
          type = lib.types.int;
          default = 12;
          description = "Bar text size in pixels.";
        };
        fontFamily = lib.mkOption {
          type = lib.types.str;
          default = "JetBrainsMono Nerd Font";
          description = "Font family used by the shell.";
        };
        launcherTextSize = lib.mkOption {
          type = lib.types.int;
          default = 16;
          description = "Launcher text size in pixels.";
        };
        panelWidth = lib.mkOption {
          type = lib.types.int;
          default = 380;
          description = "Panel width in pixels.";
        };
        panelCornerRadius = lib.mkOption {
          type = lib.types.int;
          default = 12;
          description = "Panel corner radius in pixels.";
        };
        panelTextSize = lib.mkOption {
          type = lib.types.int;
          default = 13;
          description = "Panel text size in pixels.";
        };
        extraConfig = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Additional shell configuration merged into shell.json.";
        };
      };
    };
}
