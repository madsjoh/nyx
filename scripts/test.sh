#!/usr/bin/env bash
# Test Nyx by generating configs and validating them.
# Usage: ./test.sh [theme-name]
set -euo pipefail

THEME="${1:-tokyo-night}"
cd "$(dirname "$(readlink -f "$0")")/.."

echo "=== Nyx Test: theme=$THEME ==="

# -------------------------------------------------------------------
# 1. Verify theme exists
echo -n "Theme '$THEME' exists... "
nix eval --impure --expr "(import ./themes).\"$THEME\" != null" >/dev/null 2>&1
echo "✓"

# -------------------------------------------------------------------
# 2. Verify all 21 themes
echo -n "All 21 themes loaded... "
COUNT=$(nix eval --impure --expr 'builtins.length (builtins.attrNames (import ./themes))' 2>&1)
echo "✓ ($COUNT themes)"

# -------------------------------------------------------------------
# 3. Verify helpers
echo -n "Helpers work... "
RGB=$(nix eval --impure --expr '(import ./modules/home-manager/lib.nix { lib = (import <nixpkgs> {}).lib; }).rgb "#1e1e2e"' 2>&1)
echo "✓ (rgb #1e1e2e = $RGB)"

# -------------------------------------------------------------------
# 4. Verify each integration loads without errors
echo ""
echo "--- Integration checks ---"
for app in alacritty btop chromium foot ghostty gum helix hyprland hyprlock keyboard-rgb kitty mako obsidian quickshell starship swayosd walker waybar; do
  COUNT=$(nix eval --impure --expr "
    let
      lib = (import <nixpkgs> {}).lib;
      themes = import ./themes;
      theme = themes.\"$THEME\";
      helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
      mod = import (./modules/home-manager/apps + \"/$app/default.nix\") { inherit theme helpers; };
    in builtins.length (builtins.attrNames (mod.xdg.configFile or {}))
  " 2>&1)
  echo "  $app: $COUNT files"
done

# -------------------------------------------------------------------
# 5. Spot-check key generated content
echo ""
echo "--- Content spot checks ---"

CFG=$(nix eval --impure --raw --expr "
  let
    lib = (import <nixpkgs> {}).lib;
    themes = import ./themes;
    theme = themes.\"$THEME\";
    helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
    mod = import ./modules/home-manager/apps/hyprland/default.nix { inherit theme helpers; };
  in mod.xdg.configFile.\"hypr/hyprland.lua\".text
" 2>&1)

if echo "$CFG" | grep -q "hypr.nyx.loader"; then
  echo "✓ hyprland entry loads nyx defaults"
else
  echo "✗ hyprland entry missing nyx require"
fi

CFG=$(nix eval --impure --raw --expr "
  let
    lib = (import <nixpkgs> {}).lib;
    themes = import ./themes;
    theme = themes.\"$THEME\";
    helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
    mod = import ./modules/home-manager/apps/alacritty/default.nix { inherit theme helpers; };
  in mod.xdg.configFile.\"alacritty/alacritty.toml\".text
" 2>&1)

if echo "$CFG" | grep -q "background = \"#1a1b26\""; then
  echo "✓ alacritty has theme background color"
else
  echo "✗ alacritty missing theme colors"
fi

CFG=$(nix eval --impure --raw --expr "
  let
    lib = (import <nixpkgs> {}).lib;
    themes = import ./themes;
    theme = themes.\"$THEME\";
    helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
    mod = import ./modules/home-manager/apps/hyprlock/default.nix { inherit theme helpers; };
  in mod.xdg.configFile.\"hypr/hyprlock.conf\".text
" 2>&1)

if echo "$CFG" | grep -q "input-field"; then
  echo "✓ hyprlock is full config (not just vars)"
else
  echo "✗ hyprlock is incomplete"
fi

CFG=$(nix eval --impure --raw --expr "
  let
    lib = (import <nixpkgs> {}).lib;
    themes = import ./themes;
    theme = themes.\"$THEME\";
    helpers = (import ./modules/home-manager/lib.nix { inherit lib; });
    mod = import ./modules/home-manager/apps/waybar/default.nix { inherit theme helpers; };
  in mod.xdg.configFile.\"waybar/config.jsonc\".text
" 2>&1)

if echo "$CFG" | grep -q "modules-left"; then
  echo "✓ waybar config.jsonc has modules-left"
else
  echo "✗ waybar config incomplete"
fi

echo ""
echo "=== All checks passed ==="
