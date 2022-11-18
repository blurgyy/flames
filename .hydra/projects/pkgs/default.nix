{ nixpkgs
, system
, ignoredPkgs ? []
}: with builtins; let
  pkgs = (getFlake "gitlab:highsunz/flames").pkgsInUse.${system};
  this = import ../../../packages;
  packages = this.packages pkgs;
in 
  removeAttrs (this.filterAttrs
    (name: pkg: !hasAttr "platforms" pkg.meta || elem system pkg.meta.platforms)
    packages
  ) ignoredPkgs
