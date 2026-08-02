{ theme, helpers }:
{
  xdg.configFile."alacritty/alacritty.toml".text =
    theme.overrides.alacritty or (import ./template.nix { colors = theme.colors; });
}
