{
  name = "solitude";
  colors = {
    accent = "#798186";
    cursor = "#cacccc";
    foreground = "#cacccc";
    background = "#101315";
    selection_foreground = "#101315";
    selection_background = "#798186";
    color0 = "#101315";
    color1 = "#565d60";
    color2 = "#9fa5a9";
    color3 = "#d9dbdc";
    color4 = "#798186";
    color5 = "#aeaeae";
    color6 = "#707070";
    color7 = "#cbc2be";
    color8 = "#4b4e55";
    color9 = "#de6145";
    color10 = "#343d41";
    color11 = "#c9c2b4";
    color12 = "#5d6367";
    color13 = "#9a9a9a";
    color14 = "#707070";
    color15 = "#a5aeb4";
  };
  overrides = {
    hyprland = ''
      local active_border_color = { colors = { "rgba(798186ee)", "rgba(caccccee)" }, angle = 45 }
      local inactive_border_color = "rgb(1e1e1e)"

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
      $color = rgba(16, 19, 21, 1)
      $inner_color = rgba(16, 19, 21, 1)
      $outer_color = rgba(121, 129, 134, 1)
      $font_color = rgba(202, 204, 204, 1)
      $placeholder_color = rgba(202, 204, 204, 0.7)
      $check_color = rgba(52, 61, 65, 1)
    '';
    swayosd = ''
      @define-color background-color #101315;
      @define-color border-color #2f353b;
      @define-color label #cacccc;
      @define-color image #cacccc;
      @define-color progress #d9dbdc;


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
          border-radius: 6px;
          background-color: @background-color;
          padding: 12px;
          background-clip: padding-box;
          box-shadow: 2px 2px 9px 0px rgba(22, 22, 22, 1);

      }
    '';
    waybar = ''
      @define-color background #101315;
      @define-color foreground #cacccc;
    '';
  };
}
