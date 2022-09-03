{ system, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit system self inputs;
    headless = true;
    isQemuGuest = true;
    withSecrets = false;
    withBinfmtEmulation = false;
  }) ++ [
    ./configuration.nix
    inputs.nixos-generators.nixosModules.kexec  # nix build .#nixosConfigurations.${config.networking.hostName}.config.system.build.kexec_tarball --impure
    { kexec.autoReboot = false; }
  ];
}
