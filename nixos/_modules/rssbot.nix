{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.rssbot;
in {
  options.services.rssbot = {
    enable = mkEnableOption "Whether to enable lightweight telegram RSS notification bot";
    environmentFile = mkOption {
      type = types.str;
      description = "Contains telegram bot token, variable name is RSSBOT_TOKEN";
    };
    dbFile = mkOption { type = types.str; default = "/var/lib/rssbot/db.json"; };
    package = mkOption { type = types.package; default = pkgs.rssbot; };
  };

  config = mkIf cfg.enable {
    users = {
      users.rssbot = {
        group = config.users.groups.rssbot.name;
        isSystemUser = true;
      };
      groups.rssbot = {};
    };
    systemd.services.rssbot = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cfg.package}/bin/rssbot $RSSBOT_TOKEN --database ${cfg.dbFile}
      '';
      serviceConfig = rec {
        User = config.users.users.rssbot.name;
        Group = config.users.groups.rssbot.name;
        WorkingDirectory = "/var/lib/${StateDirectory}";
        StateDirectory = "rssbot";
        StateDirectoryMode = "0700";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        EnvironmentFile = cfg.environmentFile;
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
