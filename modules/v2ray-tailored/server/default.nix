{ config, lib, usersInfo, ports, wsPath }: with builtins; let
  applyTag = overrides: path: {
    tag = with lib; strings.removeSuffix ".nix" (lists.last (splitString "/" path));
  } // (with builtins; let
    f = import path;
    in if (typeOf f) != "lambda" then
        f
      else let
        args = (intersectAttrs (functionArgs f) { inherit lib config ports wsPath; }) // overrides;
      in
    f args);
  applyUsers = set: set // {
    settings = {
      clients = map (u: {
        id = u.uuid;
        email = u.email;
        level = u.level;
        alterId = 0;
      }) usersInfo;
    };
  };
  mapDir = f: path: with builtins;
    map f
      (map (subPath: "${path}/${subPath}") (attrNames (readDir path)));
in {
  log = { loglevel = "warning"; };
  stats = {};
  api = {
    tag = "api";
    services = [ "StatsService" ];
  };
  policy = {
    levels = {
      "0" = {
        handshake = 4;
        connIdle = 300;
        uplinkOnly = 0;
        downlinkOnly = 0;
        statsUserUplink = false;
        statsUserDownlink = false;
        bufferSize = 5120;
      };
      "1" = {
        handshake = 4;
        connIdle = 300;
        uplinkOnly = 2;
        downlinkOnly = 5;
        statsUserUplink = true;
        statsUserDownlink = true;
        bufferSize = 5120;
      };
    };
  };
  system = {
    statsInboundUplink = true;
    statsInboundDownlink = true;
  };
  inbounds = mapDir (inbound: applyUsers (applyTag { inherit ports; } inbound)) ./inbounds;
  outbounds = (mapDir (applyTag {}) ./outbounds);
  routing = import ./routing { inherit applyTag mapDir; };
}
