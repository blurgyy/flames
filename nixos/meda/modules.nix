{ system, self, nixpkgs, inputs }: [
  ./configuration.nix
  inputs.nixos-wsl.nixosModules.wsl
]
