#!/usr/bin/env bash
# Dump all Nyx-generated configs to a temp directory for browsing.
# Usage: ./dump.sh [theme]
set -euo pipefail

THEME="${1:-gruvbox}"
OUTDIR="$(mktemp -d -t nyx-dump-XXXXXX)"
cd "$(dirname "$0")"
echo "Theme: $THEME  →  $OUTDIR"

count=0
for app in alacritty btop chromium foot ghostty gum helix hyprland hyprlock keyboard-rgb kitty mako obsidian quickshell swayosd walker waybar; do
  # Get list of paths this integration generates
  paths=$(nix eval --impure --raw --expr "
    let
      lib = (import <nixpkgs> {}).lib;
      themes = import ./themes;
      theme = themes.\"$THEME\";
      helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
      mod = import ./modules/home-manager/integration/$app.nix { inherit theme helpers; };
      names = builtins.attrNames mod.xdg.configFile;
    in builtins.concatStringsSep \"\n\" names
  " 2>/dev/null)

  while IFS= read -r path; do
    [ -z "$path" ] && continue
    content=$(nix eval --impure --raw --expr "
      let
        lib = (import <nixpkgs> {}).lib;
        themes = import ./themes;
        theme = themes.\"$THEME\";
        helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
        mod = import ./modules/home-manager/integration/$app.nix { inherit theme helpers; };
      in mod.xdg.configFile.\"$path\".text
    " 2>/dev/null) || continue
    mkdir -p "$(dirname "$OUTDIR/$path")"
    printf '%s\n' "$content" > "$OUTDIR/$path"
    echo "  $path"
    count=$((count + 1))
  done <<< "$paths"
done

echo ""
echo "$count files written."
echo "Browse with:  ls -R $OUTDIR"
echo "              nvim $OUTDIR/hypr/hyprland.lua"
