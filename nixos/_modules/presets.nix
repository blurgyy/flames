{ config, lib, pkgs, ... }:

let
  cfg = config.presets;
  devPackages = with pkgs; [
    colmena
    ffmpeg-full
    gcc
    glow
    hexyl
    hyperfine
    inotify-tools
    libqalculate
    litecli
    nix-output-monitor
    progress
    sops
    sqlite
    sshfs
    strace
    tokei
    typos
    xplr
    (python3.withPackages (p: with p; [
      click
      h5py
      icecream
      ipdb
      ipython
      matplotlib
      numpy
      pandas
      pillow
      plyfile
      tqdm
    ]))
    hydra-check
  ];
  entPackages = with pkgs; [
    minecraft
  ];
  recPackages = with pkgs; [
    ffmpeg-full
    typos
  ];
in

with lib;

{
  options.presets = {
    development = mkEnableOption "Setup environment for development";
    entertainment = mkEnableOption "Setup environment for entertainment";
    recreation = mkEnableOption "Setup environment for recreational purporses";
  };

  config = mkIf (builtins.any lib.id (builtins.attrValues cfg)) {
    environment.systemPackages = (optionals cfg.development devPackages)
      ++ (lib.optionals cfg.entertainment entPackages)
      ++ (lib.optionals cfg.recreation recPackages);

    programs.steam.enable = mkDefault (let
      inherit (pkgs.stdenv.hostPlatform) system;
    in (elem system [ "x86_64-linux" "i686-linux" ]) && cfg.entertainment);

    networking.firewall-tailored = mkIf cfg.entertainment {
      acceptedPorts = [{
        port = 27036;
        protocols = [ "tcp" ];
        comment = "steam remote play";
      } {
        port = "27031-27036";
        protocols = [ "udp" ];
        comment = "steam remote play";
      } {
        port = 27015;
        protocols = [ "tcp" "udp" ];
        comment = "steam dedicated server";
      }];
    };
  };
}
