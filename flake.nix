{
  description = "Nyx — Omarchy themes for NixOS + Hyprland (home-manager module)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      homeManagerModules = {
        nyx = import ./modules/home-manager { };
        default = import ./modules/home-manager { };
      };
      nixosModules = {
        nyx = import ./modules/nixos;
        default = import ./modules/nixos;
      };

      packages = forAllSystems (system: {
        nyx-shell = nixpkgs.legacyPackages.${system}.callPackage ./shell { };
      });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ gcc pkg-config fontconfig freetype libxkbcommon ];
          };
        }
      );
    };
}
