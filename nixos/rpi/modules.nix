{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  ./services
  inputs.acremote.nixosModules.default
  {
    nixpkgs.overlays = [
      (final: prev: {  # REF: <https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243>
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
      })
      inputs.acremote.overlays.default
    ];
  }
]
