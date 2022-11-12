{ system, nixpkgs, inputs, self, name, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
      (final: prev: {
        inherit (inputs.tex2nix.packages.${system}) tex2nix;
        inherit (inputs.home-manager.packages.${system}) home-manager;
        inherit (inputs.nixgl.packages.${system}) nixGLIntel;
        vimPlugins = prev.vimPlugins.extend (finalPlugins: prevPlugins: {
          vim-wakatime = prevPlugins.vim-wakatime.overrideAttrs (o: {
            patches = o.patches or [] ++ [ ./vim-wakatime-disdable-interactive-secret-prompt.patch ];
          });
          #gitsigns-nvim = prevPlugins.gitsigns-nvim.overrideAttrs (o: {
          #  src = prev.fetchFromGitHub {
          #    owner = "lewis6991";
          #    repo = "gitsigns.nvim";
          #    rev = "refs/tags/v0.5";
          #    sha256 = "sha256-kyiQoboYq4iNLOj1iKA2cfXQ9FFiRYdvf55bX5Xvj8A=";
          #  };
          #});
        });
      })
    ];
  };
  lib = nixpkgs.lib;
  myName = "gy";
  myHome = "/home/${myName}";
  helpers = import ./helpers.nix { inherit lib; };
  callWithHelpers = path: overrides: with builtins; let
    f = import path;
    args = (intersectAttrs (functionArgs f) { inherit pkgs lib name callWithHelpers; } // overrides);
  in if (typeOf f) == "set"
    then f
    else f ((intersectAttrs (functionArgs f) helpers) // args);
in inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  modules = [
    ./home.nix
    (lib.optionalAttrs (!headless) ./headful.nix)
    { home.stateVersion = "22.11"; }
  ];
  extraSpecialArgs = {
    inherit name headless proxy;
    inherit myName myHome helpers callWithHelpers;
  };
}
