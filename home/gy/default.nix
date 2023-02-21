{ system, nixpkgs, inputs, self, name, headless ? true, proxy ? null, ... }: let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        inherit (inputs.tex2nix.packages.${system}) tex2nix;
        inherit (inputs.nixos-cn.legacyPackages.${system}) re-export;
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
            patches = o.patches or [] ++ [ (pkgs.writeText "vim-wakatime-disdable-interactive-secret-prompt.patch" ''
              ---
               plugin/wakatime.vim | 3 ---
               1 file changed, 3 deletions(-)

              diff --git a/plugin/wakatime.vim b/plugin/wakatime.vim
              index 375e668..32b1d4e 100644
              --- a/plugin/wakatime.vim
              +++ b/plugin/wakatime.vim
              @@ -679,9 +679,6 @@ EOF
                       if api_key == '''
                           let api_key = s:GetIniSetting('settings', 'apikey')
                       endif
              -
              -        let api_key = inputsecret("[WakaTime] Enter your wakatime.com api key: ", api_key)
              -        call s:SetIniSetting('settings', 'api_key', api_key)
                   endfunction
               
                   function! s:EnableDebugMode()
              -- 
            '') ];
          });
        });

        python310 = prev.python310.override {
          packageOverrides = python-final: python-prev: {
            # Fixes built of bibata-cursors
            clickgen = python-prev.clickgen.overridePythonAttrs (o: {
              propagatedBuildInputs = o.propagatedBuildInputs or [] ++ [ python-prev.toml python-prev.numpy ];
              postBuild = "";
              postInstall = "";
            });
          };
        };
        # Fixes built of bibata-cursors
        bibata-cursors = prev.stdenvNoCC.mkDerivation rec {
          pname = "bibata-cursors";
          version = "2.0.3";
          src = prev.fetchFromGitHub {
            owner = "ful1e5";
            repo = "Bibata_Cursor";
            rev = "v${version}";
            hash = "sha256-zCk7qgPeae0BfzhxxU2Dk1SOWJQOxiWyJuzH/ri+Gq4=";
          };

          buildInputs = with prev.python310Packages; [
            attrs
            clickgen
          ];

          buildPhase = ''(
            declare -A names
            names["Bibata-Modern-Amber"]="Yellowish and rounded edge Bibata cursors."
            names["Bibata-Modern-Classic"]="Black and rounded edge Bibata cursors."
            names["Bibata-Modern-Ice"]="White and rounded edge Bibata cursors."
            names["Bibata-Original-Amber"]="Yellowish and sharp edge Bibata cursors."
            names["Bibata-Original-Classic"]="Black and sharp edge Bibata cursors."
            names["Bibata-Original-Ice"]="White and sharp edge Bibata cursors."

            for key in "''${!names[@]}"; do
              comment="''${names[$key]}";
              ctgen build.toml -p x11 -d "bitmaps/$key" -n "$key" -c "$comment" &
              PID=$!
              wait $PID
            done
          )'';
          installPhase = ''
            mkdir -p $out/share
            cp -r themes $out/share/icons
          '';
        };
      })
      self.overlays.default
      self.overlays.profilesShared
    ];
  };
  lib = nixpkgs.lib;
  myName = "gy";
  myHome = "/home/${myName}";
  helpers = import ./helpers.nix { inherit pkgs lib; };
  __callWithHelpers = path: overrides: with builtins; let
    f = import path;
    args = (intersectAttrs
      (functionArgs f)
      ({ inherit pkgs lib name __callWithHelpers; } // overrides)
    );
  in if (typeOf f) == "set"
    then f
    else f ((intersectAttrs (functionArgs f) helpers) // args);
in inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  modules = [
    ./home.nix
    ./secrets
    ./services
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-index-db.hmModules.nix-index
    self.homeManagerModules.default
    (lib.optionalAttrs (!headless) ./headful.nix)
    (lib.optionalAttrs (!headless) inputs.hyprland.homeManagerModules.default)
    ({ home.stateVersion = "22.11"; })
  ];
  extraSpecialArgs = {
    inherit name headless proxy;
    inherit myName myHome helpers __callWithHelpers;
  };
}
