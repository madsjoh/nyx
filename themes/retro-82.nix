{
  name = "retro-82";
  colors = {
    accent = "#faa968";
    cursor = "#f6dcac";
    foreground = "#f6dcac";
    background = "#05182e";
    selection_foreground = "#00172e";
    selection_background = "#faa968";
    color0 = "#303442";
    color1 = "#f85525";
    color2 = "#028391";
    color3 = "#e97b3c";
    color4 = "#faa968";
    color5 = "#3f8f8a";
    color6 = "#8cbfb8";
    color7 = "#a7c9c6";
    color8 = "#134e5a";
    color9 = "#f85525";
    color10 = "#028391";
    color11 = "#e97b3c";
    color12 = "#faa968";
    color13 = "#3f8f8a";
    color14 = "#8cbfb8";
    color15 = "#f6dcac";
  };
  overrides = {
    chromium = "0,23,46\n";
    hyprland = ''
      local active_border_color = "rgb(faa968)"

      hl.config({
        general = {
          col = {
            active_border = active_border_color,
          },
        },

        group = {
          col = {
            border_active = active_border_color,
          },
        },
      })
    '';
    swayosd = ''
      @define-color background-color #00172e;
      @define-color border-color #134e5a;
      @define-color label #f6dcac;
      @define-color image #f6dcac;
      @define-color progress #e97b3c;
    '';
    waybar = ''
      @define-color bg #00172e;
      @define-color foreground #f6dcac;
      @define-color background alpha(@bg, 0.8);
    '';
  };
}
