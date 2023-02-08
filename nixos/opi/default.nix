{ system, name, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    ./services
    {
      nixpkgs.overlays = [
        self.overlays.default
        self.overlays.profilesShared.${system}
      ];
    }
    {
      nixpkgs.overlays = [(final: prev: {  # REF: <https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243>
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
      })];
    }
    { networking.hostName = name; }
  ];
}
