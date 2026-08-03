# AGENTS.md

Instructions for AI coding assistants working with this repository.

## Project overview

Nyx is a Nix flake that provides themes from [Omarchy](https://omarchy.org) as a home-manager module for NixOS. Pick a theme, toggle your apps, and Nyx generates themed config files with consistent colors.

## Repository structure

```
flake.nix              — flake entrypoint, exposes homeManagerModules + nixosModules
modules/
  home-manager/        — main module (options, lib helper, per-app integrations)
    default.nix        — top-level module: theme loading, wallpaper, app imports
    options.nix        — nyx.enable, nyx.theme, nyx.<app>.enable
    lib.nix            — hex/rgb helpers
    apps/<app>/        — per-app integration: default.nix generates xdg.configFile
  nixos/               — system-level module (chromium policy)
    default.nix
themes/
  default.nix          — attrset of themeName -> import ./<theme>/theme.nix
  <theme>/             — per-theme: theme.nix (color palette) + backgrounds/
```

## Conventions

- Nix formatting: 2-space indentation, attributes alphabetized within blocks
- Theme colors: lower-case hex strings (e.g. `#1e1e2e`)
- New apps: add to `options.nix` appNames list, create `modules/home-manager/apps/<app>/default.nix` that returns `{ theme, helpers } -> { xdg.configFile = ... }`
- Commit style: conventional commits (`feat:`, `fix:`, `refactor:`, `docs:`)

## Commands

```bash
./test.sh [theme]   # validate all integrations generate valid configs (default: gruvbox)
./dump.sh [theme]   # dump all generated configs to a temp dir for manual inspection

nix flake check     # verify flake evaluates
```

The test script validates: theme existence, theme count, helpers, and that each app integration produces config files with expected content.
