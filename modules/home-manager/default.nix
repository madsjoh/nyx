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
    ({
      home.file = lib.listToAttrs (map (bg: {
        name = ".config/nyx/backgrounds/${cfg.theme}/${bg}";
        value = { source = ../../themes/${cfg.theme}/backgrounds/${bg}; };
      }) (theme.backgrounds or []));

      home.activation.nyxSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        # Create Nyx state directories
        mkdir -p "$HOME/.local/state/nyx/current"
        mkdir -p "$HOME/.local/state/nyx/toggles/hypr"

        # Symlink backgrounds dir and first image for consistent runtime paths
        ln -sfn "$HOME/.config/nyx/backgrounds/${cfg.theme}" "$HOME/.local/state/nyx/current/backgrounds"
        FIRST_BG=$(echo "${lib.concatStringsSep " " (theme.backgrounds or [])}" | cut -d' ' -f1)
        if [[ -n "$FIRST_BG" ]]; then
          ln -sfn "$HOME/.config/nyx/backgrounds/${cfg.theme}/$FIRST_BG" "$HOME/.local/state/nyx/current/background"
        fi

        # Make Nyx scripts executable
        chmod +x "$HOME"/.config/nyx/scripts/*.sh 2>/dev/null || true

        # Hyprpaper live wallpaper loading
        if hyprctl hyprpaper listactive &>/dev/null; then
          BACKGROUNDS_DIR="$HOME/.local/state/nyx/current/backgrounds"
          for bg in ${lib.concatStringsSep " " (theme.backgrounds or [])}; do
            hyprctl hyprpaper preload "$BACKGROUNDS_DIR/$bg"
          done
          FIRST_BG=$(echo "${lib.concatStringsSep " " (theme.backgrounds or [])}" | cut -d' ' -f1)
          if [[ -n "$FIRST_BG" ]]; then
            hyprctl hyprpaper wallpaper ",$BACKGROUNDS_DIR/$FIRST_BG"
          fi
        fi
      '';
    })

    (lib.mkIf cfg."alacritty".enable (import ./app/alacritty/default.nix integrationArgs))
    (lib.mkIf cfg."btop".enable (import ./app/btop/default.nix integrationArgs))
    (lib.mkIf cfg."chromium".enable (import ./app/chromium/default.nix integrationArgs))
    (lib.mkIf cfg."foot".enable (import ./app/foot/default.nix integrationArgs))
    (lib.mkIf cfg."ghostty".enable (import ./app/ghostty/default.nix integrationArgs))
    (lib.mkIf cfg."gum".enable (import ./app/gum/default.nix integrationArgs))
    (lib.mkIf cfg."helix".enable (import ./app/helix/default.nix integrationArgs))
    (lib.mkIf cfg."hyprland".enable (import ./app/hyprland/default.nix integrationArgs))
    (lib.mkIf cfg."hyprlock".enable (import ./app/hyprlock/default.nix integrationArgs))
    (lib.mkIf cfg."keyboard-rgb".enable (import ./app/keyboard-rgb/default.nix integrationArgs))
    (lib.mkIf cfg."kitty".enable (import ./app/kitty/default.nix integrationArgs))
    (lib.mkIf cfg."mako".enable (import ./app/mako/default.nix integrationArgs))
    (lib.mkIf cfg."obsidian".enable (import ./app/obsidian/default.nix integrationArgs))
    (lib.mkIf cfg."quickshell".enable (import ./app/quickshell/default.nix integrationArgs))
    (lib.mkIf cfg."swayosd".enable (import ./app/swayosd/default.nix integrationArgs))
    (lib.mkIf cfg."walker".enable (import ./app/walker/default.nix integrationArgs))
    (lib.mkIf cfg."waybar".enable (import ./app/waybar/default.nix integrationArgs))

    (lib.mkIf cfg."hyprland".enable {
      wayland.windowManager.hyprland.enable = lib.mkForce false;
    })
  ]);
}
