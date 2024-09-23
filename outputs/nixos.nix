{ self, inputs }: let
  _mkHost = (hostName: params@{ system, nixpkgs ? inputs.nixpkgs, ... }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        # NOTE: also need to update `outputs.colmena.meta.nodeSpecialArgs.${hostName}`.
        specialArgs = { inherit self inputs; };
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
  pc-x86_64-headless = {
    system = "x86_64-linux";
    headless = false;
    isQemuGuest = false;
    withBinfmtEmulation = false;
  };
  sbc-aarch64 = {
    system = "aarch64-linux";
    headless = true;
    isQemuGuest = false;
    withBinfmtEmulation = false;
  };
in mkHosts {
  copi = sbc-aarch64;
  hexa = virtual-server-x86_64;
  meda = pc-x86_64-headless;
  morty = pc-x86_64;
  octa = virtual-server-x86_64;
  opi = sbc-aarch64;
  peterpan = virtual-server-x86_64;
  sophie = virtual-server-x86_64;
  quad = virtual-server-x86_64;
  rpi = sbc-aarch64 // { nixpkgs = inputs.nixpkgs-stable; };
  rubik = virtual-server-x86_64;
  velo = virtual-server-x86_64;
  winston = pc-x86_64;
}
