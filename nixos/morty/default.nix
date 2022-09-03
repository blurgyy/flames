{ system, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit system self inputs;
    headless = false;
    isQemuGuest = false;
  }) ++ [
    ./configuration.nix
    ./network
    {
      nixpkgs.overlays = [(final: prev: {
        nbfc-linux = inputs.nbfc-linux.defaultPackage.${system};
      })];
    }
  ];
}
