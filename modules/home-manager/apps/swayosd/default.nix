{ theme, helpers }:

let
  swayosdDir = ./config;
  rf = name: builtins.readFile (swayosdDir + ("/" + name));

  themeCSS = theme.overrides.swayosd or
    (import ./template.nix { colors = theme.colors; });
in
{
  xdg.configFile = {
    "swayosd/config.toml".text = rf "config.toml";
    "swayosd/style.css".text = ''
${themeCSS}

window {
  border-radius: 0;
  opacity: 0.97;
  border: 2px solid @border-color;

  background-color: @background-color;
}

label {
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 11pt;

  color: @label;
}

image {
  color: @image;
}

progressbar {
  border-radius: 0;
}

progress {
  background-color: @progress;
}
    '';
  };
}
