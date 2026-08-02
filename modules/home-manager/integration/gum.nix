{ theme, helpers }:
{
  xdg.configFile."gum/env.lua".text =
    theme.overrides.gum or (import ../templates/gum.nix { colors = theme.colors; });
}
