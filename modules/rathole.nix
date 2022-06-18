{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.rathole;
in {
  options.services.rathole.enable = mkEnableOption "Reverse proxy with rathole";
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rathole ];
  };
}
