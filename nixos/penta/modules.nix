{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  ./services
  {
    nixpkgs.overlays = [(final: prev: let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (prev) system config;
      };
    in {
      carinae = inputs.carinae.packages.${system}.default;
      hydra-unstable = pkgs-stable.hydra-unstable.override {
        nix = pkgs-stable.nixStable;
      };
    })];
  }
]
