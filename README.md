# Nyx

Nyx provides the 21 themes from [Omarchy](https://omarchy.org) as a home-manager module for NixOS systems running Hyprland.

## Usage

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nyx.url = "github:you/nyx";
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

## Themes

21 themes: catppuccin, catppuccin-latte, ethereal, everforest, flexoki-light, gruvbox, hackerman, kanagawa, last-horizon, lumon, matte-black, miasma, nord, osaka-jade, retro-82, ristretto, rose-pine, solitude, tokyo-night, vantablack, white.

## License

MIT
