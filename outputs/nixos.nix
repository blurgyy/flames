{ self, nixpkgs, inputs }: let
  _mkHost = (hostName: params@{ system, ... }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        # NOTE: also need to update `outputs.colmena.meta.nodeSpecialArgs.${hostName}`.
        specialArgs = { inherit inputs; };
        modules = (import ../nixos/_parts/defaults {
          inherit self inputs system;
          inherit (params) headless isQemuGuest withBinfmtEmulation;
        }) ++ (
          import ../nixos/${hostName}/modules.nix {
            inherit system self nixpkgs inputs;
          }
        ) ++ [
          { networking = { inherit hostName; }; }
        ];
      }
    );
  mkHosts = attrs: builtins.mapAttrs
    _mkHost
    attrs;
  virtual-server-aarch64 = {
    system = "aarch64-linux";
    headless = true;
    isQemuGuest = true;
    withBinfmtEmulation = true;
  };
  virtual-server-x86_64 = {
    system = "x86_64-linux";
    headless = true;
    isQemuGuest = true;
    withBinfmtEmulation = true;
  };
  pc-x86_64 = {
    system = "x86_64-linux";
    headless = false;
    isQemuGuest = false;
    withBinfmtEmulation = true;
  };
  sbc-aarch64 = {
    system = "aarch64-linux";
    headless = true;
    isQemuGuest = false;
    withBinfmtEmulation = false;
  };
in mkHosts {
  cindy = virtual-server-aarch64;
  cube = virtual-server-x86_64;
  morty = pc-x86_64;
  peterpan = virtual-server-x86_64;
  quad = virtual-server-x86_64;
  rpi = sbc-aarch64;
  opi = sbc-aarch64;
  copi = sbc-aarch64;
  rubik = virtual-server-x86_64;
  trigo = virtual-server-x86_64;
}
