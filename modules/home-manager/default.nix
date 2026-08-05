{ walker ? null }:

{ config, lib, pkgs, ... }:

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

    (lib.mkIf cfg."alacritty".enable (import ./apps/alacritty/default.nix integrationArgs))
    (lib.mkIf cfg."btop".enable (import ./apps/btop/default.nix integrationArgs))
    (lib.mkIf cfg."chromium".enable (import ./apps/chromium/default.nix integrationArgs))
    (lib.mkIf cfg."foot".enable (import ./apps/foot/default.nix integrationArgs))
    (lib.mkIf cfg."ghostty".enable (import ./apps/ghostty/default.nix integrationArgs))
    (lib.mkIf cfg."gum".enable (import ./apps/gum/default.nix integrationArgs))
    (lib.mkIf cfg."helix".enable (import ./apps/helix/default.nix integrationArgs))
    (lib.mkIf cfg."hyprland".enable (import ./apps/hyprland/default.nix integrationArgs))
    (lib.mkIf cfg."hyprlock".enable (import ./apps/hyprlock/default.nix integrationArgs))
    (lib.mkIf cfg."keyboard-rgb".enable (import ./apps/keyboard-rgb/default.nix integrationArgs))
    (lib.mkIf cfg."kitty".enable (import ./apps/kitty/default.nix integrationArgs))
    (lib.mkIf cfg."mako".enable (import ./apps/mako/default.nix integrationArgs))
    (lib.mkIf cfg."obsidian".enable (import ./apps/obsidian/default.nix integrationArgs))
    (lib.mkIf cfg."quickshell".enable (import ./apps/quickshell/default.nix integrationArgs))
    (lib.mkIf cfg."swayosd".enable (import ./apps/swayosd/default.nix integrationArgs))
    (lib.mkIf cfg."walker".enable (import ./apps/walker/default.nix integrationArgs))
    (lib.mkIf (cfg."walker".enable && walker != null) (let
      walkerPackage = walker.packages.${pkgs.stdenv.system}.walker;
      elephantPackage = walker.inputs.elephant.packages.${pkgs.stdenv.system}.default;
    in {
      home.packages = [ walkerPackage elephantPackage ];
      systemd.user.services.elephant = {
        Unit = {
          Description = "Elephant launcher backend";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        Service = {
          Type = "simple";
          ExecStart = "${elephantPackage}/bin/elephant";
          Restart = "on-failure";
          RestartSec = 1;
          ExecStopPost = "${pkgs.coreutils}/bin/rm -f %t/elephant.sock";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
      home.activation.linkElephantProviders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/.config/elephant/providers
        for so in ${elephantPackage}/lib/elephant/providers/*.so; do
          ln -sfn "$so" "$HOME/.config/elephant/providers/$(basename "$so")"
        done
      '';
      home.activation.startElephant = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
        $DRY_RUN_CMD systemctl --user restart elephant 2>/dev/null || true
      '';
    }))
    (lib.mkIf cfg."waybar".enable (import ./apps/waybar/default.nix integrationArgs))

    (lib.mkIf cfg."hyprland".enable {
      wayland.windowManager.hyprland.enable = lib.mkForce false;
    })
  ]);
}
