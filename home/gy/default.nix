{ system, nixpkgs, inputs, self, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
      (final: prev: {
        tex2nix = inputs.tex2nix.packages.${system}.tex2nix;
      })
    ];
  };
  lib = nixpkgs.lib;
in inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  modules = [
    ./home.nix
    { home.stateVersion = "22.11"; }
  ];
  extraSpecialArgs = { inherit headless proxy; };
}
