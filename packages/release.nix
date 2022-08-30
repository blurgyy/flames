{ nixpkgs
, useCross ? false
, crossPlatform ? "x86_64-pc-linux-gnu"  # NOTE: see available names from <https://github.com/NixOS/nixpkgs/blob/master/lib/systems/examples.nix>
, ignoredPkgs ? []
}: let
  lib = import <nixpkgs/lib>;
  nixpkgsArgs = {
    system = "aarch64-linux";
    config.allowUnfree = true;
    config.inHydra = true;
    overlays = [ (import ./.).overlay ];
  } // (if useCross
    then { crossSystem.config = crossPlatform; }
    else {}
  );
  pkgs = import <nixpkgs> nixpkgsArgs;
in builtins.removeAttrs ((import ./.).packages pkgs) ignoredPkgs
