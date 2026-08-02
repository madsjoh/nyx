{ theme, helpers }:
{
  xdg.configFile."obsidian/themes/nyx.css".text =
    theme.overrides.obsidian or (import ./template.nix { colors = theme.colors; });
}
