{ system, nixpkgs, inputs, self, name, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = let
      waybar913-nixpkgs = builtins.getFlake "github:nixos/nixpkgs/b3c0c4979e3405f3b267e9fd1c81c4f82d8ba44d";
    in [
      self.overlays.default
      (final: prev: {
        inherit (waybar913-nixpkgs.legacyPackages.${system}) waybar;
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
in inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  modules = [
    ./home.nix
    { home.stateVersion = "22.11"; }
  ];
  extraSpecialArgs = { inherit name headless proxy; };
}
