{ config, lib, uuid, extraHosts, soMark, fwMark, ports, remotes, overseaSelectors }: with builtins; let
  applyTag = overrides: path: {
    tag = with lib; strings.removeSuffix ".nix" (lists.last (splitString "/" path));
  } // (with builtins; let
    f = import path;
    in if (typeOf f) != "lambda" then
        f
      else let
        args = (intersectAttrs (functionArgs f) { inherit lib config uuid; }) // overrides;
      in f args);
  mapDir = f: path: with builtins;
    map f
      (map (subPath: "${path}/${subPath}") (attrNames (readDir path)));
in {
  log = {
    loglevel = "warning";
    access = "/var/log/v2ray/client.log";
  };
  dns = import ./dns.nix { inherit extraHosts; };
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
  routing = import ./routing { inherit applyTag mapDir; };
  observatory = {
    subjectSelector = overseaSelectors;
    probeURL = config.sops.placeholder."v2ray/observatory-probe-url";
    probeInterval = "30s";
  };
}
