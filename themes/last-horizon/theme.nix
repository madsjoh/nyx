{
  name = "last-horizon";
  backgrounds = [
    "1-eyes-wide.jpg"
    "2-blink.jpg"
    "3-bokeh.jpg"
    "4-new-horizons.jpg"
  ];
  colors = {
    accent = "#b59790";
    cursor = "#e2dddc";
    foreground = "#FAFCFB";
    background = "#0c0b0c";
    selection_foreground = "#0c0b0c";
    selection_background = "#FAFCFB";
    color0 = "#0c0b0c";
    color1 = "#c38b7b";
    color2 = "#87a9b0";
    color3 = "#6B5E73";
    color4 = "#b59790";
    color5 = "#c4d8e2";
    color6 = "#a5a0b6";
    color7 = "#cfd3cd";
    color8 = "#584e51";
    color9 = "#c38b7b";
    color10 = "#87a9b0";
    color11 = "#6B5E73";
    color12 = "#b59790";
    color13 = "#c4d8e2";
    color14 = "#a5a0b6";
    color15 = "#e2dddc";
  };
  overrides = {
    chromium = "12,11,12\n";
    hyprland = ''
      local active_border_color = { colors = { "rgba(8a8588ee)", "rgba(e2dddcee)" }, angle = 45 }
      local inactive_border_color = "rgba(584e51aa)"

      hl.config({
        general = {
          col = {
            active_border = active_border_color,
            inactive_border = inactive_border_color,
          },
        },
        group = {
          col = {
            border_active = active_border_color,
            border_inactive = inactive_border_color,
          },
        },
      })
    '';
    hyprlock = ''
      $color = rgba(12, 11, 12, 1)
      $inner_color = rgba(12, 11, 12, 0.66)
      $outer_color = rgba(195, 139, 123, 1)
      $font_color = rgba(226, 221, 220, 1)
      $placeholder_color = rgba(255, 255, 255, 0.7)
      $check_color = rgba(181, 151, 144, 1)
    '';
    swayosd = ''
      @define-color background-color #0c0b0c;
      @define-color border-color #b59790;
      @define-color label #e2dddc;
      @define-color image #b59790;
      @define-color progress #e2dddc;


      /* Cancel out Omarchy settings */
      window:not(:backdrop),
      window:backdrop {
          border: none;
          border-width: 0;
          border-radius: 4px;
          background-color: transparent;
          box-shadow: none;
          padding: 12px;
      }


      /* Draw a new background */
      window:not(:backdrop) #container,
      window:backdrop #container {
          border: 2px solid @border-color;
          border-radius: 4px;
          background-color: @background-color;
          padding: 12px;
          background-clip: padding-box;
          box-shadow: 2px 2px 9px 0px rgba(22, 22, 22, 1);

      }
    '';
    waybar = ''
      @define-color background #0c0b0c;
      @define-color foreground #FAFCFB;
    '';
  };
}
