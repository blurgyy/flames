{ system, self, nixpkgs, inputs }:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    headless = true;
    isQemuGuest = true;
  }) ++ [
    ./configuration.nix
    #./network
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-cn.nixosModules.nixos-cn
    self.nixosModules.default
    {
      nixpkgs.overlays = [
        self.overlays.default
      ];
    }
  ];
}
