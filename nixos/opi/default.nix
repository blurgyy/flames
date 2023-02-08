{ system, name, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit self inputs system;
    headless = true;
    isQemuGuest = false;
  }) ++ [
    ./configuration.nix
    ./network
    ./services
    {
      nixpkgs.overlays = [(final: prev: {  # REF: <https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243>
        makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
      })];
    }
    { networking.hostName = name; }
  ];
}