{ theme, helpers }:
{
  xdg.configFile."alacritty/alacritty.toml".text =
    theme.overrides.alacritty or (import ../templates/alacritty.nix { colors = theme.colors; });
}
