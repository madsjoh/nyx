{ config, lib, ... }:

let
  themes = import ../../themes;
  hmCfg = config.home-manager or {};
  hmUsers = hmCfg.users or {};

  findNyxTheme = users:
    let
      pairs = lib.filterAttrs (_: u: u.nyx.enable or false) users;
      names = builtins.attrNames pairs;
    in if names == [] then null else pairs.${builtins.head names}.nyx.theme or null;

  nyxThemeName = findNyxTheme hmUsers;
  theme = if nyxThemeName != null then themes.${nyxThemeName} or null else null;

  chromiumPolicyText = ''
    {"BrowserThemeColor": "${theme.colors.background}", "BrowserColorScheme": "device"}
  '';
in
{
  config = lib.mkIf (theme != null) {
    environment.etc."chromium/policies/managed/nyx-color.json" = {
      text = chromiumPolicyText;
      mode = "0644";
    };
  };
}
