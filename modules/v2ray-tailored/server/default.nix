{ config, lib, logging, usersInfo, ports, wsPath, reverse }: with builtins; let
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
  log = {
    loglevel = "warning";
    access = if logging.access == null || logging.access == false then
        "none"
      else if logging.access == true then 
        "/var/log/v2ray/server.log"
      else
        logging.access;
    error = if logging.error == false then
        "none"
      else if logging.error == true then
        ""
      else
        logging.error;
  };
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
  inbounds = (mapDir (inbound: applyUsers (applyTag { inherit ports; } inbound)) ./inbounds)
    ++ (if (reverse == null)
    then []
    else if (reverse.position == "world")
      then [
        {
          tag = "reverse-tunnel";
          protocol = "vmess";
          port = reverse.port;
          settings.clients = [ { inherit (reverse) id; } ];
        }
      ]
      else []  # No extra inbound(s) when reverse.position is "internal"
    );
  outbounds = if (reverse == null)
    then (mapDir (applyTag {}) ./outbounds)
    else if (reverse.position == "world")
    then []  # No extra outbound(s) when reverse.position is "world"
    else [
      {
        tag = "reverse-tunnel";
        protocol = "vmess";
        settings.vnext = [
          {
            address = reverse.counterpartAddr;
            port = reverse.port;
            users = [ { inherit (reverse) id; } ];
          }
        ];
      }
    ];
  routing = if (reverse == null)
    then (import ./routing) { inherit applyTag mapDir; }
    else if (reverse.position == "world")
    then {
      domainStrategy = "IPIfNonMatch";
      domainMatcher = "mph";
      rules = (map
        (o: { type = "field"; outboundTag = "portal-${reverse.counterpartName}"; } // o) (
          [
            {  # Use this as the first rule, use full domain to route control channel traffic
              inboundTag = [ "portal-${reverse.counterpartName}" ];
              domain = [ "full:${reverse.counterpartName}.reverse.${config.networking.hostName}" ];
              outboundTag = "reverse-tunnel";
            }
          ]
          ++ (if ((length reverse.proxiedDomains) > 0) then [ { domain = reverse.proxiedDomains; } ] else [])
          ++ (if ((length reverse.proxiedIPs) > 0) then [ { ip = reverse.proxiedIPs; } ] else [])
          ++ [ { inboundTag = [ "reverse-tunnel" ]; } ]
        )
      ) ++ [
        { type = "field"; network = "tcp,udp"; outboundTag = "blocked"; }
      ];
    }
    else {
      domainStrategy = "IPIfNonMatch";
      domainMatcher = "mph";
      rules = map (o: { type = "field"; } // o) [
        {  # Use this as the first rule, use full domain to route control channel traffic
          inboundTag = [ "portal-${reverse.counterpartName}" ];
          domain = [ "full:${config.networking.hostName}.reverse.${reverse.counterpartName}" ];
          outboundTag = "reverse-tunnel";
        }
        # Direct connect to non-communication traffic
        { inboundTag = [ "portal-${reverse.counterpartName}" ]; outboundTag = "direct"; }
        # Block all other traffic
        { network = "tcp,udp"; outboundTag = "blocked"; }
      ];
    };
  reverse.portals = if (reverse != null)
  then [
    {
      tag = "portal-${reverse.counterpartName}";
      domain = if (reverse.position == "world")
        then "${reverse.counterpartName}.reverse.${config.networking.hostName}"
        else "${config.networking.hostName}.reverse.${reverse.counterpartName}";
    }
  ]
  else [];
}
