{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./services
  inputs.nickcao.nixosModules.default
  {
    nixpkgs.overlays = [(final: prev: {
      carinae = inputs.carinae.packages.${system}.default;
    })];
  }

]
