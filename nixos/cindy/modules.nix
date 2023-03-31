{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./services
  {
    nixpkgs.overlays = [(final: prev: {
      carinae = inputs.carinae.packages.${system}.default;
      inherit (import inputs.nixpkgs-stable { inherit system; }) hydra_unstable;
    })];
  }

]
