{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.rathole;
in {
  options.services.rathole = let
    token = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
    clientServiceModule = types.submodule ({ ... }: {
      options = {
        inherit name token;
        localAddr = mkOption { type = types.str; };
      };
    });
    serverServiceModule = types.submodule ({ ... }: {
      options = {
        inherit name token;
        bindAddr = mkOption { type = types.str; };
        bindPort = mkOption { type = with types; oneOf [ str int ]; };
      };
    });
    clientModule = types.submodule ({ ... }: {
      options.remoteAddr = mkOption { type = types.str; };
      options.services = mkOption { type = types.listOf clientServiceModule; default = []; };
    });
    serverModule = types.submodule ({ ... }: {
      options.bindAddr = mkOption { type = types.str; };
      options.bindPort = mkOption { type = with types; oneOf [ str int ]; };
      options.services = mkOption { type = types.listOf serverServiceModule; default = []; };
    });
  in {
    enable = mkEnableOption "Reverse proxy with rathole";
    package = mkOption { type = types.package; default = pkgs.rathole; };
    client = mkOption { type = types.nullOr clientModule; default = null; };
    server = mkOption { type = types.nullOr serverModule; default = null; };
  };
  config = mkIf cfg.enable {
    users.users.rathole = {
      group = config.users.groups.rathole.name;
      isSystemUser = true;
    };
    users.groups.rathole = {};
    networking.firewall-tailored = mkIf (cfg.server != null) {
      acceptedPorts = [{
        port = cfg.server.bindPort;
        protocols = [ "tcp" ];
        comment = "allow traffic on rathole control channel";
      }] ++ (map (svc: {
        port = svc.bindPort;
        protocols = [ "tcp" "udp" ];
        comment = "allow traffic for rathole service '${svc.name}'";
      }) cfg.server.services);
    };
    systemd.services = {
      rathole-client = mkIf (cfg.client != null) (with pkgs; {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = config.users.users.rathole.name;
          Group = config.users.groups.rathole.name;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
          LimitNOFILE = 1000000007;
          ExecStart = "${cfg.package}/bin/rathole --client ${config.sops.templates.rathole-config.path}";
          Restart = "on-failure";
          RestartSec = 5;
        };
        restartTriggers = [ (replaceStrings [ " " ] [ "" ] (concatStringsSep "" (splitString "\n" config.sops.templates.rathole-config.content))) ];
      });
      rathole-server = mkIf (cfg.server != null) (with pkgs; {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = config.users.users.rathole.name;
          Group = config.users.groups.rathole.name;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
          LimitNOFILE = 1000000007;
          ExecStart = "${cfg.package}/bin/rathole --server ${config.sops.templates.rathole-config.path}";
          Restart = "on-failure";
          RestartSec = 5;
        };
        restartTriggers = [ (replaceStrings [ " " ] [ "" ] (concatStringsSep "" (splitString "\n" config.sops.templates.rathole-config.content))) ];
      });
    };
    sops.templates.rathole-config = {
      content = let
        liftClientServices = services: listToAttrs (map
          (svc: nameValuePair svc.name { inherit (svc) token; local_addr = svc.localAddr; })
          services
        );
        liftServerServices = services: listToAttrs (map
          (svc: nameValuePair svc.name { inherit (svc) token; bind_addr = "${svc.bindAddr}:${svc.bindPort}"; })
          services
        );
      in pkgs.toTOML (removeAttrs {
        client = if (cfg.client != null) then {
          remote_addr = cfg.client.remoteAddr;
          services = liftClientServices cfg.client.services;
        } else {};
        server = if (cfg.server != null) then {
          bind_addr = "${cfg.server.bindAddr}:${cfg.server.bindPort}";
          services = liftServerServices cfg.server.services;
        } else {};
      } [
        (if (cfg.client == null) then "client" else "")
        (if (cfg.server == null) then "server" else "")
      ]);
      owner = config.users.users.rathole.name;
      group = config.users.groups.rathole.name;
    };
  };
}
