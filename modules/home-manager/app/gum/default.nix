{ theme, helpers }:
{
  xdg.configFile."gum/env.lua".text =
    theme.overrides.gum or (import ./template.nix { colors = theme.colors; });
}
