{ system, nixpkgs, inputs, self, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
      (final: prev: {
        inherit (inputs.tex2nix.packages.${system}) tex2nix;
        inherit (inputs.home-manager.packages.${system}) home-manager;
        inherit (inputs.neovim.packages.${system}) neovim;
        inherit (inputs.nixgl.packages.${system}) nixGLIntel;
        vimPlugins = prev.vimPlugins.extend (finalPlugins: prevPlugins: {
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
in inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  modules = [
    ./home.nix
    { home.stateVersion = "22.11"; }
  ];
  extraSpecialArgs = { inherit headless proxy; };
}
