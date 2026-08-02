{ colors }:
''
font-family = "JetBrainsMono Nerd Font"
font-style = Regular
font-size = 9

window-theme = ghostty
window-padding-x = 14
window-padding-y = 14
confirm-close-surface = false
resize-overlay = never
gtk-toolbar-style = flat

cursor-style = "block"
cursor-style-blink = false

shell-integration-features = no-cursor,ssh-env

keybind = shift+insert=paste_from_clipboard
keybind = control+insert=copy_to_clipboard
keybind = super+control+shift+alt+arrow_down=resize_split:down,100
keybind = super+control+shift+alt+arrow_up=resize_split:up,100
keybind = super+control+shift+alt+arrow_left=resize_split:left,100
keybind = super+control+shift+alt+arrow_right=resize_split:right,100

mouse-scroll-multiplier = 0.95

async-backend = epoll

background = ${colors.background}
foreground = ${colors.foreground}
cursor-color = ${colors.cursor}
selection-background = ${colors.selection_background}
selection-foreground = ${colors.selection_foreground}

palette = 0=${colors.color0}
palette = 1=${colors.color1}
palette = 2=${colors.color2}
palette = 3=${colors.color3}
palette = 4=${colors.color4}
palette = 5=${colors.color5}
palette = 6=${colors.color6}
palette = 7=${colors.color7}
palette = 8=${colors.color8}
palette = 9=${colors.color9}
palette = 10=${colors.color10}
palette = 11=${colors.color11}
palette = 12=${colors.color12}
palette = 13=${colors.color13}
palette = 14=${colors.color14}
palette = 15=${colors.color15}
''
