{ config, lib, name, helpers, ... }: let
  clientCfgPath = "${config.xdg.configHome}/rathole/client.toml";
  serverCfgPath = "${config.xdg.configHome}/rathole/server.toml";
  hasClientCfgPredicate = with builtins; elem "rathole/client/${name}" (attrNames config.sops.secrets);
  hasServerCfgPredicate = with builtins; elem "rathole/server/${name}" (attrNames config.sops.secrets);
in {
  sops.secrets = {
    "rathole/client/gy@cadliu" = lib.mkIf (name == "gy@cadliu") {
      path = "${config.xdg.configHome}/rathole/client.toml";
    };
    "rathole/server/gy@watson" = lib.mkIf (name == "gy@watson") {
      path = "${config.xdg.configHome}/rathole/server.toml";
    };
  };

  services.rathole = {
    enable = hasClientCfgPredicate || hasServerCfgPredicate;
    clientCfgPath = if hasClientCfgPredicate then clientCfgPath else null;
    serverCfgPath = if hasServerCfgPredicate then serverCfgPath else null;
  };
}
