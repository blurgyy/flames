{ system, nixpkgs, home-manager, self }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ self.overlays.default ];
  };
  lib = nixpkgs.lib;
in home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  modules = [ ./home.nix ];
}
