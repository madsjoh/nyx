{ theme, helpers }:
{
  xdg.configFile."helix/themes/nyx.toml".text =
    theme.overrides.helix or (import ./template.nix { colors = theme.colors; });
}
