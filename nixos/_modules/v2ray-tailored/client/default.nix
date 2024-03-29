{ config, lib, uuid, logging, extraHosts, disabledRoutingRules, soMark, fwMark, ports, remotes }: with builtins; let
  applyTag = overrides: path: {
    tag = with lib; strings.removeSuffix ".nix" (lists.last (splitString "/" path));
  } // (with builtins; let
    f = import path;
    in if (typeOf f) != "lambda" then
        f
      else let
        args = (intersectAttrs (functionArgs f) { inherit lib config uuid; }) // overrides;
      in f args);
  filterMapDir = f: siftFn: path: with builtins;
    map f
      (map
        (subPath: "${path}/${subPath}")
        (filter
          siftFn
          (attrNames (readDir path))));
  mapDir = f: path: filterMapDir f (_: true) path;
in {
  log = {
    loglevel = logging.level;
    access = if logging.access == false then
        "none"
      else if logging.access == null || logging.access == true then 
        "/var/log/v2ray/client.log"
      else
        logging.access;
    error = if logging.error == false then
        "none"
      else if logging.error == true then
        ""
      else
        logging.error;
  };
  # dns = import ./dns.nix { inherit extraHosts; };
  inbounds = mapDir (applyTag { inherit ports; }) ./inbounds;
  outbounds = let
    applyTagAndSoMark = soMark: args: path: let
      obj = applyTag args path;
    in lib.attrsets.recursiveUpdate obj { streamSettings.sockopt = { inherit soMark; }; };
    applySoMark = soMark: remote:
      lib.attrsets.recursiveUpdate remote { streamSettings.sockopt = { inherit soMark; }; };
    outbounds-servers = map (
      remote: {
        inherit (remote) tag;
        protocol = "vmess";
        settings.vnext = [
          {
            inherit (remote) address port;
            users = [ { id = uuid; security = "none"; alterId = 0; } ];
          }
        ];
        streamSettings = {
          network = "tcp";
          security = "tls";
          tlsSettings = {
            serverName = remote.domain;
            allowInsecure = remote.allowInsecure or false;
            allowInsecureCiphers = false;
          };
        };
      }
    ) remotes;
  in (mapDir (applyTagAndSoMark soMark { inherit config; }) ./outbounds-misc)
    ++ (map (applySoMark soMark) outbounds-servers);
  routing = import ./routing { inherit applyTag filterMapDir mapDir disabledRoutingRules; };
  observatory = {
    subjectSelector = let
        allSelectors = filter
          (e:
            !(builtins.any
              (prefix: lib.hasPrefix prefix e)
              ["cn" "direct-zju"]))
          (builtins.concatLists
            (mapDir (path: (import path).selector) ./routing/balancers));
      in lib.unique (builtins.sort builtins.lessThan allSelectors);
    probeURL = config.sops.placeholder."v2ray/observatory-probe-url";
    probeInterval = "30s";
  };
}
