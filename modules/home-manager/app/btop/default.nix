{ theme, helpers }:

let
  btopDir = ./config;
  rf = name: builtins.readFile (btopDir + ("/" + name));

  themeContent = theme.overrides.btop or
    (import ./template.nix { colors = theme.colors; });
in
{
  xdg.configFile = {
    "btop/btop.conf".text = rf "btop.conf";
    "btop/themes/nyx.theme".text = themeContent;
  };
}
