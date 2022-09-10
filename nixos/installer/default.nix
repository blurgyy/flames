{ system, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    inputs.nixos-generators.nixosModules.kexec  # nix build .#nixosConfigurations.${config.networking.hostName}.config.system.build.kexec_tarball --impure
    { kexec.autoReboot = false; }
  ];
}
