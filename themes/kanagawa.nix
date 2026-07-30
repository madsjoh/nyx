{
  name = "kanagawa";
  colors = {
    accent = "#7e9cd8";
    cursor = "#c8c093";
    foreground = "#dcd7ba";
    background = "#1f1f28";
    selection_foreground = "#c8c093";
    selection_background = "#2d4f67";
    color0 = "#090618";
    color1 = "#c34043";
    color2 = "#76946a";
    color3 = "#c0a36e";
    color4 = "#7e9cd8";
    color5 = "#957fb8";
    color6 = "#6a9589";
    color7 = "#c8c093";
    color8 = "#727169";
    color9 = "#e82424";
    color10 = "#98bb6c";
    color11 = "#e6c384";
    color12 = "#7fb4ca";
    color13 = "#938aa9";
    color14 = "#7aa89f";
    color15 = "#dcd7ba";
  };
  overrides = {
    hyprland = ''
      local active_border_color = "rgb(dcd7ba)"

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

      -- Kanagawa backdrop is too strong for default opacity.
      o.window({ tag = "terminal" }, { opacity = "0.98 0.95" })
    '';
  };
}
