{ system, name, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit self inputs;
    headless = true;
    isQemuGuest = true;
  }) ++ [
    ./configuration.nix
    ./services
    { networking.hostName = name; }
  ];
}
