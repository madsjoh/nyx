{
  description = "Nyx — Omarchy themes for NixOS + Hyprland (home-manager module)";

  inputs = {
    walker.url = "github:abenz1267/walker";
  };

  outputs = { self, walker }: {
    homeManagerModules = {
      nyx = import ./modules/home-manager { inherit walker; };
      default = import ./modules/home-manager { inherit walker; };
    };
    nixosModules = {
      nyx = import ./modules/nixos;
      default = import ./modules/nixos;
    };
  };
}
