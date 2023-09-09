{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  ./services
  inputs.acremote.nixosModules.default
  inputs.nixos-hardware.nixosModules.raspberry-pi-4  # for hardware encoding with v4l2m2m
  {
    nixpkgs.overlays = [
      (final: prev: {  # REF: <https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243>
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
      })
      inputs.acremote.overlays.default
    ];
  }
]
