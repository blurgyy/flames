{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./services
  {
    nixpkgs.overlays = [(final: prev: {
      carinae = inputs.carinae.packages.${system}.default;
    })];
  }
]
