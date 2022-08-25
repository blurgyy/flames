{ system, self, nixpkgs, inputs }:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ../_parts/network-defaults
    ./configuration.nix
    ./hardware.nix
    ./network.nix
    ./sops.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-cn.nixosModules.nixos-cn
    self.nixosModules.default
    {
      nixpkgs.overlays = [
        self.overlays.default
        inputs.nixos-cn.overlay
        (final: prev: {
          nbfc-linux = inputs.nbfc-linux.defaultPackage.${system};
          toTOML = inputs.nix-std.lib.serde.toTOML;
        })
      ];
    }
  ];
}
