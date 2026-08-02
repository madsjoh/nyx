{ theme, helpers }:
{
  xdg.configFile."helix/themes/nyx.toml".text =
    theme.overrides.helix or (import ../templates/helix.nix { colors = theme.colors; });
}
