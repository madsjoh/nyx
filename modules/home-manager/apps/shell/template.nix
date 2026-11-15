{ colors, options }:

builtins.toJSON {
  bar = {
    height = options.barHeight;
    corner-radius = options.cornerRadius;
    spacing = options.spacing;
    text-size = options.textSize;
    font-family = options.fontFamily;
    logo = "";
  };
  launcher = {
    width = 640;
    corner-radius = options.panelCornerRadius;
    text-size = options.launcherTextSize;
  };
  panel = {
    width = options.panelWidth;
    corner-radius = options.panelCornerRadius;
    text-size = options.panelTextSize;
  };
  colors = {
    inherit (colors)
      accent cursor foreground background
      color0 color1 color2 color3 color4 color5 color6 color7
      color8 color9 color10 color11 color12 color13 color14 color15;
    selection-foreground = colors.selection_foreground;
    selection-background = colors.selection_background;
  };
}
