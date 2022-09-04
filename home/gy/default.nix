{ system, nixpkgs, inputs, self, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
      inputs.neovim-nightly-overlay.overlay
      (final: prev: {
        tex2nix = inputs.tex2nix.packages.${system}.tex2nix;
        difftastic = (import inputs.nixpkgs-difftastic-terminal-width-fix { inherit system; }).difftastic;
        vimPlugins = prev.vimPlugins.extend (finalPlugins: prevPlugins: {
          nvim-treesitter = prevPlugins.nvim-treesitter.overrideAttrs (o: {
            patches = [
              (prev.fetchpatch {
                url = "https://patch-diff.githubusercontent.com/raw/nvim-treesitter/nvim-treesitter/pull/3365.patch";
                sha256 = "sha256-3gbQimnozaCRCIHKSPwDFiyqSXmewMQAa8YMrw1kI/k=";
              })
            ];
          });
          gitsigns-nvim = prevPlugins.gitsigns-nvim.overrideAttrs (o: {
            src = prev.fetchFromGitHub {
              owner = "lewis6991";
              repo = "gitsigns.nvim";
              rev = "refs/tags/v0.5";
              sha256 = "sha256-kyiQoboYq4iNLOj1iKA2cfXQ9FFiRYdvf55bX5Xvj8A=";
            };
          });
        });
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
