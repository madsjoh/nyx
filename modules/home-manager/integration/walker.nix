{ theme, helpers }:

let
  walkerDir = ../walker;
  rf = name: builtins.readFile (walkerDir + ("/" + name));

  themeCSS = theme.overrides.walker or
    (import ../templates/walker.nix { colors = theme.colors; });
in
{
  xdg.configFile = {
    "walker/config.toml".text = rf "config.toml";
    "walker/themes/nyx/style.css".text = ''
${themeCSS}

* {
  all: unset;
}

* {
  font-family: monospace;
  font-size: 18px;
  color: @text;
}

scrollbar {
  opacity: 0;
}

.normal-icons {
  -gtk-icon-size: 16px;
}

.large-icons {
  -gtk-icon-size: 32px;
}

.box-wrapper {
  background: alpha(@base, 0.95);
  padding: 20px;
  border: 2px solid @border;
}

.box {
}

.search-container {
  background: @base;
  padding: 10px;
}

.input placeholder {
  opacity: 0.5;
}

.input {
}

.input:focus,
.input:active {
  box-shadow: none;
  outline: none;
}

.content-container {
}

.placeholder {
}

.scroll {
}

.list {
}

child,
child > * {
}

child:hover .item-box {
}

child:selected .item-box {
}

child:selected .item-box * {
  color: @selected-text;
}

child:selected {
  background: alpha(@text, 0.07);
}

.item-box {
  padding-left: 14px;
}

.item-text-box {
  all: unset;
  padding: 14px 0;
}

.item-text {
}

.item-subtext {
  font-size: 0px;
  min-height: 0px;
  margin: 0px;
  padding: 0px;
}

.item-image {
  margin-right: 14px;
  -gtk-icon-transform: scale(0.9);
}

.current {
  font-style: italic;
}

.keybind-hints {
  background: @background;
  padding: 10px;
  margin-top: 10px;
}
    '';

    "walker/themes/nyx/layout.xml".text = rf "themes/nyx/layout.xml";
    "walker/restart.conf".text = rf "restart.conf";
    "walker/walker.desktop".text = rf "walker.desktop";
  };
}
