{ config, lib, name, helpers, ... }: let
  clientCfgPath = "${config.xdg.configHome}/rathole/client.toml";
  serverCfgPath = "${config.xdg.configHome}/rathole/server.toml";
  hasClientCfgPredicate = with builtins; elem "rathole/client/${name}" (attrNames config.sops.secrets);
  hasServerCfgPredicate = with builtins; elem "rathole/server/${name}" (attrNames config.sops.secrets);
in {
  sops.secrets = {
    # client
    "rathole/client/gy@cadliu" = lib.mkIf (name == "gy@cadliu") { path = clientCfgPath; };
    "rathole/client/gy@cad-liu" = lib.mkIf (name == "gy@cad-liu") { path = clientCfgPath; };

    # server
    "rathole/server/gy@watson" = lib.mkIf (name == "gy@watson") { path = serverCfgPath; };
  };

  services.rathole = {
    enable = hasClientCfgPredicate || hasServerCfgPredicate;
    clientCfgPath = if hasClientCfgPredicate then clientCfgPath else null;
    serverCfgPath = if hasServerCfgPredicate then serverCfgPath else null;
  };
}
