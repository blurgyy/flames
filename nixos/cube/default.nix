{ system, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit system self inputs;
    headless = true;
    isQemuGuest = true;
  }) ++ [
    ./configuration.nix
    ./services
  ];
}
