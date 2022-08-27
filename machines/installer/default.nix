{ system, self, nixpkgs, inputs }:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    headless = true;
    isQemuGuest = true;
    withSecrets = false;
  }) ++ [
    ./configuration.nix
    inputs.nixos-cn.nixosModules.nixos-cn
    self.nixosModules.default
    inputs.nixos-generators.nixosModules.kexec  # nix build .#nixosConfigurations.${config.networking.hostName}.config.system.build.kexec_tarball --impure
    { kexec.autoReboot = false; }
    {
      nixpkgs.overlays = [
        self.overlays.default
      ];
    }
  ];
}
