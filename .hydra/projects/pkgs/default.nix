{ nixpkgs
, system
, ignoredPkgs ? []
}: let
  this = import ../../../packages;
  nixpkgsArgs = {
    inherit system;
    config.allowUnfree = true;
    config.inHydra = true;
    overlays = [ this.overlay ];
  };
  pkgs = import <nixpkgs> nixpkgsArgs;
in builtins.removeAttrs (this.packages pkgs) ignoredPkgs
