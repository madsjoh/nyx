# Nyx

> Omarchy themes for NixOS — a home-manager module that themes your desktop with one setting.

Nyx is a [Nix flake](https://wiki.nixos.org/wiki/Flakes) that brings themes from [Omarchy](https://omarchy.org) to NixOS. It provides a **home-manager module** that generates themed configs for every supported app, plus a **NixOS module** for system-level policies.

## Quick start

Add Nyx to your flake inputs and home-manager modules:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nyx.url = "github:madsjoh/nyx";
  };
  outputs = { nixpkgs, home-manager, nyx, ... }: {
    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        nyx.homeManagerModules.nyx
        {
          nyx = {
            enable = true;
            theme = "tokyo-night";
          };
        }
      ];
    };
  };
}
```

All apps are enabled by default. Disable any you don't want themed with `nyx.<app>.enable = false`.

## Supported applications

Nyx themes these 17 apps — all enabled by default, individually toggleable:

| | | |
|---|---|---|
| alacritty | btop | chromium |
| foot | ghostty | gum |
| helix | hyprland | hyprlock |
| keyboard-rgb | kitty | mako |
| obsidian | quickshell | swayosd |
| walker | waybar | |

## Themes

catppuccin · catppuccin-latte · ethereal · everforest · flexoki-light · gruvbox · hackerman · kanagawa · last-horizon · lumon · matte-black · miasma · nord · osaka-jade · retro-82 · ristretto · rose-pine · solitude · tokyo-night · vantablack · white

> See each theme's colors on [omarchy.org](https://omarchy.org).

## Flake outputs

| Output | Description |
|---|---|
| `homeManagerModules.nyx` | Themes apps and manages wallpaper |
| `homeManagerModules.default` | Alias for `nyx` |
| `nixosModules.nyx` | System-level policies (e.g. chromium) |
| `nixosModules.default` | Alias for `nyx` |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nyx.enable` | bool | `false` | Enable Nyx theming |
| `nyx.theme` | enum | `"gruvbox"` | Active theme |
| `nyx.<app>.enable` | bool | `true` | Toggle theming per app |

## Development

```bash
./test.sh [theme]   # validate all integrations generate valid configs
./dump.sh [theme]   # dump generated configs to a temp directory for inspection
```

## License

MIT
