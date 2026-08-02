{ theme, helpers }:

let
  makoDir = ../mako;
  rf = name: builtins.readFile (makoDir + ("/" + name));

  themeConfig = theme.overrides.mako or
    (import ../templates/mako.nix { colors = theme.colors; });
in
{
  xdg.configFile = {
    "mako/config".text = ''
${themeConfig}

anchor=top-right
group-by=app-name,summary,body
default-timeout=5000
width=420
outer-margin=20
padding=10,15
border-size=2
max-icon-size=32
font=sans-serif 14px

[mode=do-not-disturb]
invisible=true

[mode=do-not-disturb app-name=notify-send]
invisible=false

[urgency=critical]
default-timeout=0
layer=overlay
    '';
  };
}
