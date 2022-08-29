{ self
, nixpkgs
, useCross ? false
, crossSystem ? "x86_64-linux"
, scrubJobs ? true  # Strip most of the attributes when evaluating to spare memory usage (REF: <https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/release-cross.nix>
, nixpkgsArgs ? { config = { allowUnfree = true; inHydra = true; }; }
}: let
  args = nixpkgsArgs // { overlays = [ (import ./.).overlay ]; };
  pkgs = import <nixpkgs> (if useCross then
    (args // {
      crossSystem = (import <nixpkgs/lib>).systems.examples."${crossSystem}-multiplatform";
    })
    else args
  );
in ((import ./.).packages pkgs)
