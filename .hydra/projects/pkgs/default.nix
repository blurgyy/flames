{ nixpkgs
, system
, ignoredPkgs ? []
}: with builtins; let
  nixpkgsArgs = {
    inherit system;
    config.allowUnfree = true;
    config.inHydra = true;
    overlays = (getFlake "gitlab:highsunz/flames").overlaysInUse.${system};
  };
  pkgs = import nixpkgs nixpkgsArgs;
  this = import ../../../packages;
  packages = this.packages pkgs;
in 
  removeAttrs (this.filterAttrs
    (name: pkg: !hasAttr "platforms" pkg.meta || elem system pkg.meta.platforms)
    packages
  ) ignoredPkgs
