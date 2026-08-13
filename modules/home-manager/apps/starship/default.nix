{ theme, helpers }:

let
  themeConfig = theme.overrides.starship or
    (import ./template.nix { colors = theme.colors; });
in
{
  xdg.configFile = {
    "starship.toml".text = themeConfig;
  };
}
