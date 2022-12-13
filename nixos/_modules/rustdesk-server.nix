{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.rustdesk-server;
in {
  options.services.rustdesk-server = {
    enable = mkEnableOption "Whether to enable RustDesk server program";
    package = mkOption { type = types.package; default = pkgs.rustdesk-server; };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users = {
      users.rustdesk = {
        group = config.users.groups.rustdesk.name;
        isSystemUser = true;
      };
      groups.rustdesk = {};
    };

    systemd.services = let
      sharedServiceConfig = rec {
        User = config.users.users.rustdesk.name;
        Group = config.users.groups.rustdesk.name;
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        StateDirectory = "rustdesk-server";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/${StateDirectory}";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        LimitNOFILE = 1000000007;
        Restart = "on-failure";
        RestartSec = 5;
      };
    in {
      rustdesk-id = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = sharedServiceConfig // {
          ExecStart = "${cfg.package}/bin/hbbs";
        };
      };
      rustdesk-relay = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = sharedServiceConfig // {
          ExecStart = "${cfg.package}/bin/hbbr";
        };
      };
    };

    networking.firewall-tailored.acceptedPorts = [{
      port = 21115;
      protocols = [ "tcp" ];
      comment = "rustdesk-server NAT type test";
    } {
      port = 21116;
      protocols = [ "udp" ];
      comment = "rustdesk-server ID registration and heartbeat service";
    } {
      port = 21116;
      protocols = [ "tcp" ];
      comment = "rustdesk-server TCP hole punching and connection service";
    } {
      port = 21117;
      protocols = [ "tcp" ];
      comment = "rustdesk-server relay services";
    } {
      port = 21118;
      protocols = [ "tcp" ];
      comment = "rustdesk-server web clients (optional)";
    } {
      port = 21119;
      protocols = [ "tcp" ];
      comment = "rustdesk-server web clients (optional)";
    }];
  };
}
