{ system, self, nixpkgs, inputs }: [
  inputs.nixos-wsl.nixosModules.wsl

  ./configuration.nix
  ./network
]
