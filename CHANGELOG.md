# Changelog

## [0.3.0](https://github.com/madsjoh/nyx/compare/v0.2.0...v0.3.0) (2026-08-03)


### Features

* change default theme to tokyo-night ([#4](https://github.com/madsjoh/nyx/issues/4)) ([aa1ed95](https://github.com/madsjoh/nyx/commit/aa1ed9570dd59c2f44847723dc78bbee413d3271))

## [0.2.0](https://github.com/madsjoh/nyx/compare/v0.1.0...v0.2.0) (2026-08-03)


### Features

* add all 21 omarchy theme color definitions ([0c2865c](https://github.com/madsjoh/nyx/commit/0c2865c9e912d0e23709770b12c43e77a46cf973))
* add hex color helpers (strip, rgb) ([abd6cdc](https://github.com/madsjoh/nyx/commit/abd6cdc540c65cd4e180d12da4b73c72b6bb064a))
* add module options (theme selector + per-app toggles) ([754ce5f](https://github.com/madsjoh/nyx/commit/754ce5ff94b1fc917f1a628ce624a569a6ba6c83))
* add per-theme overrides for 9 themes ([e1567f9](https://github.com/madsjoh/nyx/commit/e1567f961445c8906a0cd8c064f1f0fcba74bb18))
* add SUPER+CTRL+SPACE to cycle backgrounds ([734b226](https://github.com/madsjoh/nyx/commit/734b2264dffd52aac31ed07032462a3eaa45d0f1))
* bar + notification templates + integrations (waybar, mako, swayosd, walker, quickshell) ([b0bdca7](https://github.com/madsjoh/nyx/commit/b0bdca77802d2009487f46c39f56143e85064788))
* desktop + editor templates + integrations (hyprland, hyprlock, btop, helix, gum, obsidian, chromium, keyboard-rgb) ([6897a2b](https://github.com/madsjoh/nyx/commit/6897a2b9c929e9a2e4c515764c5dddf5f2dd0049))
* generate full working app configs, not just theme snippets ([85ceb84](https://github.com/madsjoh/nyx/commit/85ceb84f35d3fec970b6ec7d2f84f5e709cdd4b4))
* hyprpaper live reload on theme switch ([e0727c4](https://github.com/madsjoh/nyx/commit/e0727c45a4b77da1a44e6cf1208dc734733229e3))
* initial Nyx release with Omarchy theming ([9cd6634](https://github.com/madsjoh/nyx/commit/9cd6634cef97f5b903e824783a3ff1967592d41a))
* install backgrounds and current symlink ([d435b95](https://github.com/madsjoh/nyx/commit/d435b95db8411df13766f89abecbf51ce880a357))
* terminal templates + integrations (alacritty, foot, ghostty, kitty) ([92d0f2f](https://github.com/madsjoh/nyx/commit/92d0f2f885cc54fc479453d927814b2d1694cce0))
* wire module default.nix with all 17 integrations ([566acb6](https://github.com/madsjoh/nyx/commit/566acb6ee2e23f1c6cfa3ea1bbfef18021eb2ce3))


### Bug Fixes

* background source path relative to flake root for pure eval ([3ea875b](https://github.com/madsjoh/nyx/commit/3ea875bb3b0e68bee48b5419fca2917908711bf1))
* **chromium:** generate BrowserThemeColor policy via NixOS module ([6f0ccab](https://github.com/madsjoh/nyx/commit/6f0ccaba53543ee6207ff60d4764edb61ec4835e))
* copy missing .luarc.json to hyprland config ([fe14d49](https://github.com/madsjoh/nyx/commit/fe14d49c8d971fbb7394581c27866ae99bda7880))
* cycle background round-robin alphabetical order ([c8150a9](https://github.com/madsjoh/nyx/commit/c8150a9f1066d210889aa57c1b7df3eb112da19f))
* default browser chromium not firefox in hyprland bindings ([556f0b6](https://github.com/madsjoh/nyx/commit/556f0b691e4c50e83dba3671893e09dc6769a6f8))
* deploy waybar scripts via home.file with executable=true ([8740888](https://github.com/madsjoh/nyx/commit/874088897f88f9ae9401b06f8a8bc755541aba02))
* disable home-manager hyprland module when nyx hyprland is enabled to prevent config conflict ([8258e86](https://github.com/madsjoh/nyx/commit/8258e8674b1483e7334251110737485e8d99afbd))
* inline background cycle command (nix store is read-only) ([32a2138](https://github.com/madsjoh/nyx/commit/32a2138c5e5be829435cb350bea3da105f76e2f0))
* keyboard-rgb hyphen syntax, LICENSE attribution, spec update ([10a80e2](https://github.com/madsjoh/nyx/commit/10a80e2588d7500da41596de5ae8e7bf657a5325))
* kill stale swaybg before starting new one ([fe1fba9](https://github.com/madsjoh/nyx/commit/fe1fba9f2ff185f1a756f4262fbe83e7a2373dbe))
* load bindings.lua in loader; change close-window to SUPER+Q ([b0059db](https://github.com/madsjoh/nyx/commit/b0059db71b1df6290d71664aeb31b1e1986cfbe3))
* replace arch icon with nix logo in waybar ([9c0f669](https://github.com/madsjoh/nyx/commit/9c0f6699aa3c1777743fe3b9ac5ead0f0b15cbae))
* symlink first background image for swaybg and hyprlock ([9d07121](https://github.com/madsjoh/nyx/commit/9d0712187ad9ea6b8e1911375788b382e15cf2e1))
* **test.sh:** fix missed app→apps rename on loop line ([359e56d](https://github.com/madsjoh/nyx/commit/359e56d84e48fc45dbc2c17fefcd89d60c8e70c5))
* **test.sh:** update import paths to app/&lt;app&gt;/default.nix ([ffab58c](https://github.com/madsjoh/nyx/commit/ffab58c4692f13d263a00d524bc18fca65d1515b))
* use #!/usr/bin/env bash for NixOS compatibility ([c725a81](https://github.com/madsjoh/nyx/commit/c725a818cda2f0c9c2c36eec5e168db469ccc935))
* use killall not pkill for swaybg; don't background ([69b8a3e](https://github.com/madsjoh/nyx/commit/69b8a3e8307e2392f633af628d52f78af866db8c))
* **waybar:** show temperature alongside weather icon ([ef8d50c](https://github.com/madsjoh/nyx/commit/ef8d50c9fdf16274b6db751650a3d833ef344923))
* **waybar:** trim location to city name only in tooltip ([d4c816d](https://github.com/madsjoh/nyx/commit/d4c816ddbe01c282bdf238b69cada35c5745a8f5))
* **waybar:** use wttr.in %c emoji icon instead of %C text for weather ([cf39a4c](https://github.com/madsjoh/nyx/commit/cf39a4c09fd59307a08afd857a789e58d4992174))
* **waybar:** use wttr.in format %l:+%c+%t with location in tooltip ([09af30a](https://github.com/madsjoh/nyx/commit/09af30a924fe0f6cf71c0739e419071fae597fb0))


### Documentation

* comma-separated app list ([1750612](https://github.com/madsjoh/nyx/commit/17506121510e7c36559ea102f3813c0f2013130a))
* improve README and add AGENTS.md and gitignore ([bf72961](https://github.com/madsjoh/nyx/commit/bf729614588ed57a427c9104a0d425c082a628b3))
* initial release setup ([881f578](https://github.com/madsjoh/nyx/commit/881f5787d5afd4f880dddd983cb1eec2de876aa4))
* remove redundant /Wayland from README ([14637bd](https://github.com/madsjoh/nyx/commit/14637bdf2bd0d1903f911a781267398796bcf0df))
