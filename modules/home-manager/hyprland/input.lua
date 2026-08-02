-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "compose:caps",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    accel_profile = "adaptive",

    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,

    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      clickfinger_behavior = true,
      disable_while_typing = true,
      scroll_factor = 0.4,
    },
  },

  misc = {
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})

-- Scroll nicely in the terminal.
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
