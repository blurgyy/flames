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
    serverServiceModule = types.submodle ({ ... }: {
      options = {
        inherit name token;
        bindAddr = mkOption { type = types.str; };
      };
    });
    clientModule = types.submodule ({ ... }: {
      options.remoteAddr = mkOption { type = types.str; };
      options.services = mkOption { type = types.listOf clientServiceModule; default = []; };
    });
    serverModule = types.submodule ({ ... }: {
      options.bindAddr = mkOption { type = types.str; };
      options.services = mkOption { type = types.listOf serverServiceModule; default = []; };
    });
  in {
    enable = mkEnableOption "Reverse proxy with rathole";
    package = mkOption { type = types.package; default = pkgs.rathole; };
    client = mkOption { type = types.nullOr clientModule; default = null; };
    server = mkOption { type = types.nullOr serverModule; default = null; };
  };
  config = mkIf cfg.enable {
    systemd.services.rathole-client = mkIf (cfg.client != null) (with pkgs; {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rathole --client ${config.sops.templates.rathole-config.path}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      restartTriggers = [ (replaceStrings [ " " ] [ "" ] (concatStringsSep "" (splitString "\n" config.sops.templates.rathole-config.content))) ];
    });
    sops.templates.rathole-config.content = let
      lift = services: listToAttrs
        (map
          (service: let
            renameRules = { localAddr = "local_addr"; bindAddr = "bind_addr"; };
            attrs = removeAttrs service [ "name" ];
          in nameValuePair service.name (listToAttrs
            (attrValues
              (mapAttrs
                (name: value: {
                  name = if (hasAttr name renameRules) then renameRules.${name} else name;
                  inherit value;
                })
                attrs)
              )
            )
          )
          services
        );
    in pkgs.toTOML (removeAttrs {
      client = if (cfg.client != null) then {
        remote_addr = cfg.client.remoteAddr;
        services = lift cfg.client.services;
      } else {};
      server = if (cfg.server != null) then {
        bind_addr = cfg.server.bindAddr;
        services = lift cfg.server.services;
      } else {};
    } [
      (if (cfg.client == null) then "client" else "")
      (if (cfg.server == null) then "server" else "")
    ]);
  };
}
