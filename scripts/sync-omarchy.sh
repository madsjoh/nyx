#!/bin/bash
# Sync omarchy themes and templates into nyx.
# Run from the nyx repo root. Requires omarchy checkout at $1.

set -euo pipefail

OMARCHY_DIR="${1:?Usage: $0 <omarchy-checkout-dir>}"
NYX_DIR="$(cd "$(dirname "$0")/.." && pwd)"

THEMES_DIR="$NYX_DIR/themes"
TPL_DIR="$NYX_DIR/modules/home-manager/templates"
INT_DIR="$NYX_DIR/modules/home-manager/integration"
OPTIONS_FILE="$NYX_DIR/modules/home-manager/options.nix"
DEFAULT_FILE="$NYX_DIR/modules/home-manager/default.nix"
SYNC_FILE="$NYX_DIR/.omarchy-sync"

# Standard 22 color keys in order
read -r -d '' COLOR_KEYS <<'EOF' || true
accent
cursor
foreground
background
selection_foreground
selection_background
color0
color1
color2
color3
color4
color5
color6
color7
color8
color9
color10
color11
color12
color13
color14
color15
EOF

# Template-to-app mapping: <template-file> <app-name> <xdg-config-path>
# hyprland-preview-share-picker is intentionally excluded
read -r -d '' TPL_MAP <<'EOF' || true
alacritty.toml.tpl alacritty alacritty/alacritty.toml
btop.theme.tpl btop btop/themes/nyx.theme
chromium.theme.tpl chromium nyx/chromium.theme
foot.ini.tpl foot foot/foot.ini
ghostty.conf.tpl ghostty ghostty/config
gum_env.lua.tpl gum gum/env.lua
helix.toml.tpl helix helix/themes/nyx.toml
hyprland.lua.tpl hyprland hypr/hyprland.lua
hyprlock.conf.tpl hyprlock hypr/hyprlock.conf
keyboard.rgb.tpl keyboard-rgb nyx/keyboard.rgb
kitty.conf.tpl kitty kitty/nyx-theme.conf
mako.ini.tpl mako mako/config
obsidian.css.tpl obsidian obsidian/themes/nyx.css
quickshell.json.tpl quickshell quickshell/config.json
swayosd.css.tpl swayosd swayosd/style.css
walker.css.tpl walker walker/config.css
waybar.css.tpl waybar waybar/nyx-theme.css
EOF

# Override file-to-app mapping: <omarchy-file> <nyx-override-key>
read -r -d '' OVERRIDE_MAP <<'EOF' || true
waybar.css waybar
hyprland.lua hyprland
hyprlock.conf hyprlock
swayosd.css swayosd
chromium.theme chromium
keyboard.rgb keyboard-rgb
EOF

# ---- Theme regeneration ----

parse_colors() {
  local colors_toml="$1"
  for key in $COLOR_KEYS; do
    local val
    val=$(grep -E "^\s*${key}\s*=\s*\"#[0-9a-fA-F]{6}\"" "$colors_toml" 2>/dev/null | head -1 | sed 's/.*"\(#[^"]*\)".*/\1/')
    if [[ -n $val ]]; then
      echo "colors.$key"
    fi
  done
}

extract_overrides() {
  local theme_file="$1"
  if [[ ! -f $theme_file ]]; then
    return
  fi
  # Handle both single-line {} and multi-line { ... } blocks
  if grep -q 'overrides = {};' "$theme_file"; then
    echo '  overrides = {};'
  else
    sed -n '/^  overrides = {/,/^  };$/p' "$theme_file"
  fi
}

write_theme_file() {
  local name="$1" colors_toml="$2" existing_nyx_file="$3"
  local output="$THEMES_DIR/${name}.nix"

  local overrides_block=""
  if [[ -f $existing_nyx_file ]]; then
    overrides_block=$(extract_overrides "$existing_nyx_file")
  fi
  if [[ -z $overrides_block ]]; then
    overrides_block="  overrides = {};"
  fi

  {
    echo "{"
    echo "  name = \"$name\";"
    echo "  colors = {"

    local any_colors=0
    while IFS='=' read -r key val; do
      key="${key//[\"\' ]/}"
      [[ -n $key && $key != \#* ]] || continue
      val="${val#*\"}"
      val="${val%%\"*}"
      [[ $val =~ ^# ]] || continue

      case $key in
        accent|cursor|foreground|background|selection_foreground|selection_background|color0|color1|color2|color3|color4|color5|color6|color7|color8|color9|color10|color11|color12|color13|color14|color15)
          printf '    %s = "%s";\n' "$key" "$val"
          any_colors=1
          ;;
      esac
    done <"$colors_toml"

    echo "  };"
    echo "$overrides_block"
    echo "}"
  } >"$output"

  [[ $any_colors -eq 1 ]] || { echo "WARNING: no colors parsed for $name"; rm -f "$output"; }
}

# ---- Template conversion ----

convert_tpl_to_nix() {
  local tpl_file="$1" app="$2"

  local uses_strip=0 uses_rgb=0
  grep -q '_strip' "$tpl_file" 2>/dev/null && uses_strip=1
  grep -q '_rgb' "$tpl_file" 2>/dev/null && uses_rgb=1

  local args="colors"
  [[ $uses_strip -eq 1 || $uses_rgb -eq 1 ]] && args="$args, helpers"

  echo "{ $args }:"
  echo "''"

  while IFS= read -r line; do
    # Strip omarchy-specific include paths from mako template
    if [[ $app == "mako" && $line =~ include=.*omarchy ]]; then
      continue
    fi

    # Replace in order: _rgb and _strip first (more specific), then bare keys last
    line=$(echo "$line" | sed \
      -e 's|{{ \([a-zA-Z0-9_]*\)_rgb }}|${helpers.rgb colors.\1}|g' \
      -e 's|{{ \([a-zA-Z0-9_]*\)_strip }}|${helpers.strip colors.\1}|g' \
      -e 's|{{ \([a-zA-Z0-9_]*\) }}|${colors.\1}|g')

    echo "$line"
  done <"$tpl_file"

  echo "''"
}

# ---- Main ----

main() {
  local sync_hash
  sync_hash=$(git -C "$OMARCHY_DIR" rev-parse HEAD)

  if [[ -f $SYNC_FILE ]]; then
    local current_hash
    current_hash=$(cat "$SYNC_FILE")
    if [[ $sync_hash == "$current_hash" ]]; then
      echo "Already synced to $sync_hash, nothing to do."
      exit 0
    fi
  fi

  echo "Syncing omarchy → nyx ($sync_hash)"

  # 1. Regenerate themes
  local theme_names=""
  for theme_dir in "$OMARCHY_DIR/themes"/*/; do
    [[ -d $theme_dir ]] || continue
    local name
    name=$(basename "$theme_dir")
    local colors_toml="$theme_dir/colors.toml"

    if [[ -f $colors_toml ]]; then
      theme_names="$theme_names $name"
      # Fix naming: replace hyphens with nothing for filename mapping
      # e.g. catppuccin-latte → catppuccin-latte.nix, tokyo-night → tokyo-night.nix
      local nyx_file="$THEMES_DIR/${name}.nix"
      write_theme_file "$name" "$colors_toml" "$nyx_file"

      # Detect per-theme override files
      detect_overrides "$theme_dir" "$name"
    fi
  done

  # Remove stale nyx theme files (themes no longer in omarchy)
  for nf in "$THEMES_DIR"/*.nix; do
    [[ -f $nf ]] || continue
    local nf_name
    nf_name=$(basename "$nf" .nix)
    if [[ $nf_name == "default" ]]; then
      continue
    fi
    if [[ ! -d $OMARCHY_DIR/themes/$nf_name ]]; then
      echo "Removing stale theme: $nf_name"
      rm -f "$nf"
    fi
  done

  # 2. Regenerate templates
  local app_names=""
  while read -r tpl_file app xdg_path; do
    [[ -n $tpl_file ]] || continue
    local tpl_path="$OMARCHY_DIR/default/themed/$tpl_file"

    if [[ -f $tpl_path ]]; then
      echo "Converting template: $tpl_file → $app"
      convert_tpl_to_nix "$tpl_path" "$app" >"$TPL_DIR/${app}.nix"

      # Ensure integration file exists
      if [[ ! -f $INT_DIR/${app}.nix ]]; then
        write_integration "$app" "$xdg_path"
      fi

      app_names="$app_names $app"
    fi
  done <<<"$TPL_MAP"

  # 3. Update themes/default.nix
  write_themes_default "$theme_names"

  # 4. Update options.nix
  write_options "$theme_names" "$app_names"

  # 5. Update modules/home-manager/default.nix
  write_module_default "$app_names"

  # 6. Update .omarchy-sync
  echo "$sync_hash" >"$SYNC_FILE"

  echo "Sync complete. Theme count: $(echo "$theme_names" | wc -w). App count: $(echo "$app_names" | wc -w)."
}

detect_overrides() {
  local theme_dir="$1" theme_name="$2"

  while read -r om_file override_key; do
    [[ -n $om_file ]] || continue
    local override_path="$theme_dir/$om_file"

    if [[ -f $override_path ]]; then
      echo "INFO: theme $theme_name has override $override_key ($om_file)"
      # If the nyx theme file exists, check if the override is already present
      local nyx_theme="$THEMES_DIR/${theme_name}.nix"
      if [[ -f $nyx_theme ]]; then
        if ! grep -q "$override_key = ''" "$nyx_theme" 2>/dev/null; then
          echo "  → override exists but nyx file missing $override_key entry — manual review needed"
        fi
      fi
    fi
  done <<<"$OVERRIDE_MAP"
}

write_integration() {
  local app="$1" xdg_path="$2"
  local out="$INT_DIR/${app}.nix"

  cat >"$out" <<INTEOF
{ theme, helpers }:
{
  xdg.configFile."${xdg_path}".text =
    theme.overrides."${app}" or (import ../templates/${app}.nix { colors = theme.colors; inherit helpers; });
}
INTEOF

  echo "Created integration: $app"
}

write_themes_default() {
  local names="$1"
  local out="$THEMES_DIR/default.nix"

  {
    echo "{"
    for name in $names; do
      echo "  $name = import ./${name}.nix;"
    done
    echo "}"
  } >"$out"
}

write_options() {
  local theme_names="$1" app_names="$2"
  local out="$OPTIONS_FILE"

  local theme_list=""
  for t in $theme_names; do
    theme_list="$theme_list \"$t\""
  done

  local app_list=""
  for a in $app_names; do
    app_list="$app_list    \"$a\""
  done

  cat >"$out" <<OPTEOF
{ lib, themes }:

let
  themeNames = builtins.attrNames themes;
  appNames = [
$app_list
  ];
  mkAppOption = name: {
    \${name} = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Nyx theming for \${name}";
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
OPTEOF
}

write_module_default() {
  local app_names="$1"
  local out="$DEFAULT_FILE"

  {
    echo "{ config, lib, ... }:"
    echo ""
    echo "let"
    echo "  cfg = config.nyx;"
    echo "  themes = import ../../themes;"
    echo '  theme = themes.${cfg.theme} or (throw "Unknown nyx theme: ${cfg.theme}");'
    echo "  helpers = import ./lib.nix { inherit lib; };"
    echo "  integrationArgs = { inherit theme helpers; };"
    echo "in"
    echo "{"
    echo "  imports = ["
    echo "    (import ./options.nix { inherit lib themes; })"
    echo "  ];"
    echo ""
    echo "  config = lib.mkIf cfg.enable (lib.mkMerge ["

    for app in $app_names; do
      echo "    (lib.mkIf cfg.\"${app}\".enable (import ./integration/${app}.nix integrationArgs))"
    done

    echo "  ]);"
    echo "}"
  } >"$out"
}

main "$@"
