#!/usr/bin/env bash
# Cycle to the next background and reload swaybg.
set -euo pipefail

BG_DIR="$HOME/.local/state/nyx/current/backgrounds"
BG_LINK="$HOME/.local/state/nyx/current/background"

current=$(readlink -f "$BG_LINK")
next=$(find "$BG_DIR" -maxdepth 1 -type f | sort | grep -A1 "^$current$" | tail -1)
[ -z "$next" ] && next=$(find "$BG_DIR" -maxdepth 1 -type f | sort | head -1)

ln -sfn "$next" "$BG_LINK"
pkill swaybg || true
swaybg -i "$BG_LINK" -m fill &
