o.bind("SUPER + SPACE", "Launch apps", { launch = "walker" })
o.bind("SUPER + CTRL + E", "Emoji picker", { launch = "walker -m symbols" })
o.bind("SUPER + ESCAPE", "System menu", { launch = "wlogout" })

o.bind("XF86Calculator", "Calculator", "gnome-calculator")

o.bind("SUPER + SHIFT + SPACE", "Toggle top bar", "pkill -USR1 waybar")

o.bind("SUPER + COMMA", "Dismiss last notification", "makoctl dismiss")
o.bind("SUPER + SHIFT + COMMA", "Dismiss all notifications", "makoctl dismiss --all")
o.bind("SUPER + CTRL + COMMA", "Toggle silencing notifications", "makoctl mode -t do-not-disturb")
o.bind("SUPER + ALT + COMMA", "Invoke last notification", "makoctl invoke")
o.bind("SUPER + SHIFT + ALT + COMMA", "Restore last notification", "makoctl restore")

o.bind("PRINT", "Screenshot", "grim -g \"$(slurp)\" - | wl-copy")
o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + CTRL + PRINT", "Extract text (OCR) from screenshot", "grim -g \"$(slurp)\" - | tesseract stdin stdout | wl-copy")

o.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)

o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

o.bind("SUPER + CTRL + SPACE", "Next background", 'sh -c \'BG=$(ls "$HOME"/.local/state/nyx/current/backgrounds/ | sort -R | head -1); ln -sfn "$HOME/.local/state/nyx/current/backgrounds/$BG" "$HOME/.local/state/nyx/current/background"; pkill swaybg; swaybg -i "$HOME/.local/state/nyx/current/background" -m fill &\'')

o.bind("SUPER + CTRL + L", "Lock system", "loginctl lock-session")
