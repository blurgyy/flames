{ config, lib, pkgs, ... }:

let
  cfg = config.home.presets;
  devPackages = with pkgs; [
    bat
    btop
    clang-tools
    colmena
    exa
    exiftool
    ffmpeg-full
    file
    fish
    fzf
    gdb
    glow
    hexyl
    hydra-check
    imagemagick
    inotify-tools
    libime-history-merge
    litecli
    lnav
    lsof
    nix-output-monitor
    nvfetcher
    parallel
    patchelf
    pciutils
    progress
    q-text-as-data
    sops
    sqlite
    strace
    tex2nix
    tokei
    tro
    typos
    xplr
  ] ++ lib.optional (let
    inherit (pkgs.stdenv.hostPlatform) system;
  in system == "x86_64-linux" || system == "i686-linux") conda;
  entPackages = with pkgs; [
  ];
  recPackages = with pkgs; [
    exiftool
    ffmpeg-full
    imagemagick
    yt-dlp
  ];
in

with lib;

{
  options.home.presets = {
    development = mkEnableOption "Setup environment for development";
    entertainment = mkEnableOption "Setup environment for entertainment";
    recreation = mkEnableOption "Setup environment for recreational purporses";
  };

  config = mkIf (builtins.any lib.id (builtins.attrValues cfg)) {
    home.packages = (optionals cfg.development devPackages)
      ++ (lib.optionals cfg.entertainment entPackages)
      ++ (lib.optionals cfg.recreation recPackages);
  };
}