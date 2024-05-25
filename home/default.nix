{ userName
, hostName
, system
, self
, nixpkgs
, inputs
, headless ? true
, proxy ? null
}:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.cudaSupport = builtins.elem hostName [
      "cad-liu"
      "cadliu"
      "meda"
      "mono"
      "winston"
      "vdm0"
    ];
    overlays = [
      inputs.ntfy-bridge.overlays.default
      (final: prev: {
        inherit (inputs.tex2nix.packages.${system}) tex2nix;
        inherit (inputs.home-manager.packages.${system}) home-manager;
        inherit (inputs.nixgl.packages.${system}) nixGLIntel;
        inherit (inputs.hypr-msg-handler.packages.${system}) hypr-execonce-helper hypr-last-workspace-recorder;
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
          };
        };
      })
      self.overlays.default
    ] ++ self.sharedOverlays;
  };
  lib = nixpkgs.lib;
  myName = userName;
  myHome = "/${lib.optionalString (myName != "root") "home/"}${myName}";
  helpers = import ./_parts/_helpers.nix { inherit pkgs lib; };
  __callWithHelpers = path: overrides: with builtins; let
    f = import path;
    args = (intersectAttrs
      (functionArgs f)
      ({ inherit pkgs lib headless hostName proxy __callWithHelpers; } // overrides)
    );
  in if (typeOf f) == "set"
    then f
    else f ((intersectAttrs (functionArgs f) helpers) // args);
in inputs.home-manager.lib.homeManagerConfiguration {
  inherit lib pkgs;
  extraSpecialArgs = {
    inherit inputs;
    inherit userName hostName headless proxy;
    inherit myName myHome helpers __callWithHelpers;
  };
  modules = [
    ./${userName}
    ./_parts/defaults
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-index-db.hmModules.nix-index
    inputs.ntfy-bridge.hmModules.default
    self.homeManagerModules.default
    (lib.optionalAttrs ((!headless) && (builtins.pathExists ./${userName}/headful.nix)) ./${userName}/headful.nix)
    ({ home.stateVersion = "24.05"; })
  ];
}
