{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./services
  ./network
  inputs.adrivems.nixosModules.default
]
