{ theme, helpers }:
{
  xdg.configFile."obsidian/themes/nyx.css".text =
    theme.overrides.obsidian or (import ../templates/obsidian.nix { colors = theme.colors; });
}
