{ system, name, self, nixpkgs, inputs }: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = (import ../_parts/defaults {
    inherit self inputs system;
    headless = true;
    isQemuGuest = true;
    withBinfmtEmulation = true;
  }) ++ [
    ./configuration.nix
    ./services
    { networking.hostName = name; }
  ];
}
