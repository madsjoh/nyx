{ theme, helpers, options ? {
  barHeight = 26;
  cornerRadius = 0;
  spacing = 8;
  textSize = 12;
  fontFamily = "JetBrainsMono Nerd Font";
  launcherTextSize = 16;
  panelWidth = 380;
  panelCornerRadius = 12;
  panelTextSize = 13;
  extraConfig = { };
} }:

let
  generated = import ./template.nix { colors = theme.colors; inherit options; };
  merged =
    if options.extraConfig == { } then
      generated
    else
      builtins.toJSON ((builtins.fromJSON generated) // options.extraConfig);
in
{
  xdg.configFile."nyx/shell.json".text = theme.overrides.shell or merged;
}
