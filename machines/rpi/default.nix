{ system, self, nixpkgs, inputs }:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    ./sops.nix
    inputs.sops-nix.nixosModules.sops
    {
      nixpkgs.overlays = [
        self.overlays.default
        (final: prev: {
          acremote = inputs.acremote.packages.${system}.default;
        })
        (final: prev: {  # REF: https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
          makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
        })
      ];
    }
  ];
}
