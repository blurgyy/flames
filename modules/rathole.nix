{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.rathole;
in {
  options.services.rathole = {
    enable = mkEnableOption "Reverse proxy with rathole";
    package = mkOption {
      type = types.package;
      default = pkgs.rathole;
    };
    configFile = mkOption {
      type = with types; oneOf [ path str ];
    };
  };
  config = mkIf cfg.enable {
    systemd.services.rathole = with pkgs; {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rathole ${config.services.rathole.configFile}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
