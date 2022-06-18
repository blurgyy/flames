{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.rathole;
in {
  options.services.rathole = {
    enable = mkEnableOption "Reverse proxy with rathole";
    configFile = mkOption {
      type = with types; oneOf [ path string ];
    };
  };
  config = mkIf cfg.enable {
    systemd.services.rathole = with pkgs; {
      wantedBy = [ "multi-user.target" ];
      script = ''${rathole}/bin/rathole ${config.services.rathole.configFile}'';
      unitConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
