{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  ./services
  {
    nixpkgs.overlays = [
      (final: prev: {  # REF: <https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243>
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
        opi3lts-kernel = inputs.orangepi-3-lts-nixos.packages.${system}.linux;
        opi3lts-uboot = inputs.orangepi-3-lts-nixos.packages.${system}.ubootOrangePi3Lts;
        opi-firmware = inputs.orangepi-3-lts-nixos.packages.${system}.firmware;
      })
    ];
  }
]
