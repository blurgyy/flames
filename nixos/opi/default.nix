{ system, name, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit self inputs system;
    headless = true;
    isQemuGuest = false;
  }) ++ [
    ./configuration.nix
    ./network
    ./services
    inputs.aliyundrive-mediaserver.nixosModules.default
    {
      nixpkgs.overlays = [
        (final: prev: {  # REF: <https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243>
          makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
          opi3lts-kernel-latest = inputs.orangepi-3-lts-nixos.packages.${system}.linux_latest;
          opi3lts-uboot = inputs.orangepi-3-lts-nixos.packages.${system}.ubootOrangePi3Lts;
          opi-firmware = inputs.orangepi-3-lts-nixos.packages.${system}.firmware;
        })
        inputs.aliyundrive-mediaserver.overlays.default
      ];
    }
    { networking.hostName = name; }
  ];
}
