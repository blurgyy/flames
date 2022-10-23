{ system, name, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit self inputs;
    headless = false;
    isQemuGuest = false;
    withBinfmtEmulation = true;
  }) ++ [
    ./configuration.nix
    ./network
    {
      nixpkgs.overlays = [(final: prev: {
        nbfc-linux = inputs.nbfc-linux.defaultPackage.${system};
      })];
    }
    { networking.hostName = name; }
  ];
  extraModules = [ inputs.colmena.nixosModules.deploymentOptions ];
}
