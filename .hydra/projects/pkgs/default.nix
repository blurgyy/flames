{ nixpkgs
, system
, ignoredPkgs ? []
}: with builtins; let
  this = import ../../../packages;
  nixpkgsArgs = {
    inherit system;
    config.allowUnfree = true;
    config.inHydra = true;
    overlays = [ this.overlay ];
  };
  pkgs = import <nixpkgs> nixpkgsArgs;
  packages = this.packages pkgs;
in 
  removeAttrs (this.filterAttrs
    (name: pkg: !hasAttr "platforms" pkg.meta || elem system pkg.meta.platforms)
    packages
  ) ignoredPkgs
