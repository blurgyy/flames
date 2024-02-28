{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  ./services
  {
    nixpkgs.overlays = [(final: prev: {
      carinae = inputs.carinae.packages.${system}.default;
    })];
  }
]
