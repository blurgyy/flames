{ nixpkgs
, system
, ignoredPkgs ? []
}: let
  nixpkgsArgs = {
    inherit system;
    config.allowUnfree = true;
    config.inHydra = true;
    overlays = [ (import ./.).overlay ];
  };
  pkgs = import <nixpkgs> nixpkgsArgs;
in builtins.removeAttrs ((import ./.).packages pkgs) ignoredPkgs
