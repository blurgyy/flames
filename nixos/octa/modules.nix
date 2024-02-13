{ system, nixpkgs, inputs, self }: [
  ./configuration.nix
  ./network
  ./services
  {
    nixpkgs.overlays = [
      (final: prev: let
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit (prev) system config;
        };
      in {
        # NOTE: qemu is overlayed to use version from nixpkgs stable release
        inherit (pkgs-stable) qemu;
      })
      inputs.adrivems.overlays.default
    ];
  }
]
