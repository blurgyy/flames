{ system, nixpkgs, inputs, self, name, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        inherit (inputs.tex2nix.packages.${system}) tex2nix;
        inherit (inputs.home-manager.packages.${system}) home-manager;
        inherit (inputs.nixgl.packages.${system}) nixGLIntel;
        inherit (inputs.hyprland.packages.${system}) hyprland wlroots-hyprland;
        inherit (inputs.hyprpaper.packages.${system}) hyprpaper;
        inherit (inputs.hypr-msg-handler.packages.${system}) hypr-execonce-helper hypr-last-workspace-recorder;
        hyprland-XDG_CURRENT_DESKTOP-sway = inputs.hyprland.packages.${system}.hyprland.overrideAttrs (o: {
          # set XDG_CURRENT_DESKTOP to sway and export it to systemd and dbus to use flameshot properly
          postPatch = ''
            sed -Ee 's/"XDG_CURRENT_DESKTOP", "Hyprland"/"XDG_CURRENT_DESKTOP", "sway"/' -i src/Compositor.cpp 
          '';
        });
        vimPlugins = prev.vimPlugins.extend (finalPlugins: prevPlugins: {
          vim-wakatime = prevPlugins.vim-wakatime.overrideAttrs (o: {
            patches = o.patches or [] ++ [ ./vim-wakatime-disdable-interactive-secret-prompt.patch ];
          });
          #gitsigns-nvim = prevPlugins.gitsigns-nvim.overrideAttrs (o: {
          #  src = prev.fetchFromGitHub {
          #    owner = "lewis6991";
          #    repo = "gitsigns.nvim";
          #    rev = "refs/tags/v0.5";
          #    hash = "sha256-kyiQoboYq4iNLOj1iKA2cfXQ9FFiRYdvf55bX5Xvj8A=";
          #  };
          #});
        });
      })
      self.overlays.default
    ];
  };
  lib = nixpkgs.lib;
  myName = "gy";
  myHome = "/home/${myName}";
  helpers = import ./helpers.nix { inherit pkgs lib; };
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
    ./secrets
    inputs.sops-nix-hm.homeManagerModules.sops
    (lib.optionalAttrs (!headless) ./headful.nix)
    (lib.optionalAttrs (!headless) inputs.hyprland.homeManagerModules.default)
    { home.stateVersion = "22.11"; }
  ];
  extraSpecialArgs = {
    inherit name headless proxy;
    inherit myName myHome helpers callWithHelpers;
  };
}
