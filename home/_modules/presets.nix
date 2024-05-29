{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.home.presets;

  blender_with_packages = (pkgs.blender-ply-as-verts.withPackages (pp: with pp; [
    pillow
    scipy
    tqdm
  ]));

  devPackages = with pkgs; [
    bat
    clang-tools
    colmena
    eza
    exiftool
    ffmpeg-fuller
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
    mayo
    nix-output-monitor
    nvfetcher
    parallel
    patchelf
    pciutils
    pcl
    q-text-as-data
    sops
    sqlite
    strace
    tex2nix
    tokei
    tro
    typos
    xplr
  ] ++ lib.optional (system == "x86_64-linux" || system == "i686-linux") conda
    ++ lib.optional (system == "x86_64-linux") blender_with_packages;
  entPackages = with pkgs; [
  ];
  recPackages = with pkgs; [
    exiftool
    ffmpeg-fuller
    # gimp
    imagemagick
    mayo
    yt-dlp
  ] ++ lib.optional (system == "x86_64-linux") blender_with_packages;
  sciPackages = with pkgs; [
    inkscape
    labelme
  ];
in

with lib;

{
  options.home.presets = {
    development = mkEnableOption "Setup environment for development";
    entertainment = mkEnableOption "Setup environment for entertainment";
    recreation = mkEnableOption "Setup environment for recreational purporses";
    scientific = mkEnableOption "Setup environment for scientific purporses";
    sans-systemd = mkEnableOption "Adjust settings for environments without systemd";
  };

  config = mkIf (builtins.any lib.id (builtins.attrValues cfg)) {
    home.packages = (optionals cfg.development devPackages)
      ++ (lib.optionals cfg.entertainment entPackages)
      ++ (lib.optionals cfg.recreation recPackages)
      ++ (lib.optionals cfg.scientific sciPackages)
      ;
    home.activation.dconfSettings = lib.mkIf config.home.presets.sans-systemd (lib.mkForce "");
  };
}
