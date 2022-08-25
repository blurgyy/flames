{ system, self, nixpkgs, inputs }:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ../_parts/network-defaults
    ../_parts/server-defaults/configuration.nix
    ../_parts/server-defaults/hardware.nix
    ./configuration.nix
    ./network
    ./sops.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-cn.nixosModules.nixos-cn
    self.nixosModules.default
    #inputs.nixos-generators.nixosModules.kexec  # nix build .#nixosConfigurations.cube.config.system.build.kexec_tarball --impure
    {
      nixpkgs.overlays = [
        self.overlays.default
        (final: prev: {
          toTOML = inputs.nix-std.lib.serde.toTOML;
        })
      ];
    }
  ];
}
