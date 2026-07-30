{ colors }:
''
[colors.primary]
background = "${colors.background}"
foreground = "${colors.foreground}"

[colors.cursor]
text = "${colors.background}"
cursor = "${colors.cursor}"

[colors.vi_mode_cursor]
text = "${colors.background}"
cursor = "${colors.cursor}"

[colors.search.matches]
foreground = "${colors.background}"
background = "${colors.color3}"

[colors.search.focused_match]
foreground = "${colors.background}"
background = "${colors.color1}"

[colors.footer_bar]
foreground = "${colors.background}"
background = "${colors.foreground}"

[colors.selection]
text = "${colors.selection_foreground}"
background = "${colors.selection_background}"

[colors.normal]
black = "${colors.color0}"
red = "${colors.color1}"
green = "${colors.color2}"
yellow = "${colors.color3}"
blue = "${colors.color4}"
magenta = "${colors.color5}"
cyan = "${colors.color6}"
white = "${colors.color7}"

[colors.bright]
black = "${colors.color8}"
red = "${colors.color9}"
green = "${colors.color10}"
yellow = "${colors.color11}"
blue = "${colors.color12}"
magenta = "${colors.color13}"
cyan = "${colors.color14}"
white = "${colors.color15}"
''
