{ system, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    headless = false;
    isQemuGuest = false;
  }) ++ [
    ./configuration.nix
    ./network
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-cn.nixosModules.nixos-cn
    inputs.acremote.nixosModules.${system}.default
    self.nixosModules.default
    {
      nixpkgs.overlays = [
        self.overlays.default
        (final: prev: {
          acremote = inputs.acremote.packages.${system}.default;
          toTOML = inputs.nix-std.lib.serde.toTOML;
        })
        (final: prev: {  # REF: https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
          makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
        })
      ];
    }
  ];
}
