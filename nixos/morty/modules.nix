{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  {
    nixpkgs.overlays = [(final: prev: {
      nbfc-linux = inputs.nbfc-linux.defaultPackage.${system};
    })];
  }
]
