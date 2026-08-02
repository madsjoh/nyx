{ theme, helpers }:

let
  btopDir = ../btop;
  rf = name: builtins.readFile (btopDir + ("/" + name));

  themeContent = theme.overrides.btop or
    (import ../templates/btop.nix { colors = theme.colors; });
in
{
  xdg.configFile = {
    "btop/btop.conf".text = rf "btop.conf";
    "btop/themes/nyx.theme".text = themeContent;
  };
}
