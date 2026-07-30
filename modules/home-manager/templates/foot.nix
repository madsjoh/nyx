{ colors, helpers }:
''
[colors-dark]
foreground=${helpers.strip colors.foreground}
background=${helpers.strip colors.background}
selection-foreground=${helpers.strip colors.selection_foreground}
selection-background=${helpers.strip colors.selection_background}

cursor=${helpers.strip colors.background} ${helpers.strip colors.cursor}

regular0=${helpers.strip colors.color0}
regular1=${helpers.strip colors.color1}
regular2=${helpers.strip colors.color2}
regular3=${helpers.strip colors.color3}
regular4=${helpers.strip colors.color4}
regular5=${helpers.strip colors.color5}
regular6=${helpers.strip colors.color6}
regular7=${helpers.strip colors.color7}

bright0=${helpers.strip colors.color8}
bright1=${helpers.strip colors.color9}
bright2=${helpers.strip colors.color10}
bright3=${helpers.strip colors.color11}
bright4=${helpers.strip colors.color12}
bright5=${helpers.strip colors.color13}
bright6=${helpers.strip colors.color14}
bright7=${helpers.strip colors.color15}
''
