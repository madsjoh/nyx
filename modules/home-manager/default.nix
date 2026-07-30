{ config, lib, ... }:

let
  cfg = config.nyx;
  themes = import ../../themes;
  theme = themes.${cfg.theme} or (throw "Unknown nyx theme: ${cfg.theme}");
  helpers = import ./lib.nix { inherit lib; };
  integrationArgs = { inherit theme helpers; };
in
{
  imports = [
    (import ./options.nix { inherit lib themes; })
  ];

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg."alacritty".enable (import ./integration/alacritty.nix integrationArgs))
    (lib.mkIf cfg."btop".enable (import ./integration/btop.nix integrationArgs))
    (lib.mkIf cfg."chromium".enable (import ./integration/chromium.nix integrationArgs))
    (lib.mkIf cfg."foot".enable (import ./integration/foot.nix integrationArgs))
    (lib.mkIf cfg."ghostty".enable (import ./integration/ghostty.nix integrationArgs))
    (lib.mkIf cfg."gum".enable (import ./integration/gum.nix integrationArgs))
    (lib.mkIf cfg."helix".enable (import ./integration/helix.nix integrationArgs))
    (lib.mkIf cfg."hyprland".enable (import ./integration/hyprland.nix integrationArgs))
    (lib.mkIf cfg."hyprlock".enable (import ./integration/hyprlock.nix integrationArgs))
    (lib.mkIf cfg."keyboard-rgb".enable (import ./integration/keyboard-rgb.nix integrationArgs))
    (lib.mkIf cfg."kitty".enable (import ./integration/kitty.nix integrationArgs))
    (lib.mkIf cfg."mako".enable (import ./integration/mako.nix integrationArgs))
    (lib.mkIf cfg."obsidian".enable (import ./integration/obsidian.nix integrationArgs))
    (lib.mkIf cfg."quickshell".enable (import ./integration/quickshell.nix integrationArgs))
    (lib.mkIf cfg."swayosd".enable (import ./integration/swayosd.nix integrationArgs))
    (lib.mkIf cfg."walker".enable (import ./integration/walker.nix integrationArgs))
    (lib.mkIf cfg."waybar".enable (import ./integration/waybar.nix integrationArgs))
  ]);
}
