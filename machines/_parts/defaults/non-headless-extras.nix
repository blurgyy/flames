{ config, lib, pkgs, ... }: rec {
  boot.initrd.kernelModules = [ "i915" "amdgpu" ];

  programs = {
    light.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    opengl = {
      # NOTE: needed to get sway to work.  (See https://search.nixos.org)
      enable = true;
      extraPackages = with pkgs; [ vaapiIntel ];
    };
  };

  # Enable pipewire (see NixOS Wiki)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    media-session.enable = false;
  };

  # Needed for swaylock to work
  security.pam.services.swaylock = { };

  fonts = let
    fontConfsRoot = ../raw/fontconfig;
  in {
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = let
        generic-fallbacks = [
          "emoji"
          "codicon"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "Font Awesome 5 Free"
          "Font Awesome 5 Brands"
          "Symbols Nerd Font"
        ];
      in rec {
        serif = [
          "Source Serif Pro"
          "Source Han Serif SC"
          "Source Han Serif TC"
          "Source Han Serif HC"
          "Source Han Serif K"
          "LXGW Wenkai"
        ] ++ generic-fallbacks;
        # NOTE: "HarmonyOS Sans" won't work.  Use "HarmonyOS Sans SC", etc.
        sansSerif = [
          "Rubik"
          "HarmonyOS Sans SC"
          "HarmonyOS Sans TC"
          "Source Sans Pro"
          "Source Han Sans SC"
          "Source Han Sans TC"
          "Source Han Sans HC"
          "Source Han Sans K"
          "LXGW Wenkai"
        ] ++ generic-fallbacks;
        monospace = [
          "Iosevka Fixed"
          "Source Code Pro"
        ] ++ sansSerif;
        emoji = [ "Apple Color Emoji" ];
      };
      # includeUserConf = true;
      localConf = with builtins;
        ''<?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE fontconfig SYSTEM "url:fontconfig:fonts.dtd">
        <fontconfig>
        '' +
        concatStringsSep "\n" (
          map (f: readFile "${fontConfsRoot}/${f}") (
            attrNames (readDir fontConfsRoot)
          )
        ) +
        "</fontconfig>";
    };
    fonts = with pkgs; [
      rubik
      (iosevka-bin.override { variant = "sgr-iosevka-fixed"; })
      (iosevka-bin.override { variant = "sgr-iosevka-slab"; })
      source-sans-pro
      source-han-sans
      source-serif-pro
      source-han-serif
      source-code-pro
      font-awesome
      liberation_ttf
      lxgw-wenkai
      harmonyos-sans
      symbols-nerd-font
      vscode-codicons
      apple-color-emoji
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    #gtkUsePortal = true;  # It's deprecated (for some reason, enable this and see trace message while rebuilding)
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # needed for opening filechooser
  };
}
