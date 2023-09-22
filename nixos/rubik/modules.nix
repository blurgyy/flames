{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./services
  inputs.adrivems.nixosModules.default
]
