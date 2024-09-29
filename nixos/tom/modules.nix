{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./services
  inputs.zstdp.nixosModules.default
  { nixpkgs.overlays = [ inputs.zstdp.overlays.default ]; }
]
