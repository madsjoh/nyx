{
  name = "lumon";
  backgrounds = [
    "01-united-in-severance.jpg"
    "02-opinions-equally.jpg"
  ];
  colors = {
    accent = "#8bc9eb";
    cursor = "#f2fcff";
    foreground = "#d6e2ee";
    background = "#16242d";
    selection_foreground = "#1b2d40";
    selection_background = "#4d9ed3";
    color0 = "#1b2d40";
    color1 = "#4d86b0";
    color2 = "#5e95bc";
    color3 = "#6fa4c9";
    color4 = "#6fb8e3";
    color5 = "#8bc9eb";
    color6 = "#b4e4f6";
    color7 = "#d6e2ee";
    color8 = "#304860";
    color9 = "#73a6cb";
    color10 = "#86b7d8";
    color11 = "#9dcae5";
    color12 = "#f2fcff";
    color13 = "#b1d8ee";
    color14 = "#d1eef8";
    color15 = "#ffffff";
  };
  overrides = {
    chromium = "14,31,41\n";
    hyprland = ''
      local active_border_color = "rgb(f2fcff)"
      local active_shadow_color = "rgb(6fb8e3)"
      local inactive_border_color = "rgba(30486099)"
      local inactive_shadow_color = "rgba(30486077)"

      hl.config({
        general = {
          col = {
            active_border = active_border_color,
            inactive_border = inactive_border_color,
          },
          gaps_in = 8,
          gaps_out = 16,
        },

        group = {
          col = {
            border_active = active_border_color,
            border_inactive = inactive_border_color,
          },
        },

        decoration = {
          shadow = {
            enabled = true,
            range = 16,
            render_power = 4,
            color = active_shadow_color,
            color_inactive = inactive_shadow_color,
          },
        },
      })
    '';
    swayosd = ''
      @define-color background-color #1b2d40;
      @define-color border-color #304860;
      @define-color label #d6e2ee;
      @define-color image #d6e2ee;
      @define-color progress #6fb8e3;
      @define-color edge-light #f2fcff;

      /* Cancel out Omarchy defaults */
      window:not(:backdrop),
      window:backdrop {
          border: none;
          border-width: 0;
          background-color: transparent;
          box-shadow: none;
          padding: 12px;
      }

      /* Draw the Lumon OSD shell */
      window:not(:backdrop) #container,
      window:backdrop #container {
          border: 2px solid alpha(@border-color, 0.92);
          background-color: alpha(@background-color, 0.95);
          padding: 12px 16px;
          background-clip: padding-box;
      }

      image,
      label {
          color: @label;
      }

      progressbar {
          min-height: 8px;
      }

      progressbar trough {
          background: alpha(@border-color, 0.24);
          box-shadow: inset 0 1px rgba(242, 252, 255, 0.03);
      }

      progressbar progress {
          background: linear-gradient(90deg, @progress, @edge-light);
          box-shadow: 0 0 10px rgba(111, 184, 227, 0.18);
      }
    '';
    waybar = ''
      @define-color foreground #d6e2ee;
      @define-color background #213442;
    '';
  };
}
