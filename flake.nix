{
  description = "Nyx — Omarchy themes for NixOS + Hyprland (home-manager module)";

  outputs = { self }: {
    homeManagerModules = {
      nyx = import ./modules/home-manager;
      default = import ./modules/home-manager;
    };
    nixosModules = {
      nyx = import ./modules/nixos;
      default = import ./modules/nixos;
    };
  };
}
