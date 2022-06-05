{ lib, config }: let
  applyTag = overrides: path: {
    tag = with lib;
      strings.removeSuffix ".nix" (lists.last (splitString "/" path));
  } // (with builtins; let
    f = import path;
    in if (typeOf f) != "lambda" then
        f
      else let
        args = (intersectAttrs (functionArgs f) { inherit lib config; }) // overrides;
      in f args);
  importDir = f: path: with builtins;
    map f
      (map (subPath: "${path}/${subPath}") (attrNames (readDir path)));
in {
  log = {
    loglevel = "warning";
    access = "none";
  };
  dns = import ./dns.nix { inherit config; };
  inbounds = importDir (applyTag { inherit config; }) ./inbounds;
  outbounds = let
    applyTagAndSoMark = mark: path: let
      obj = applyTag { } path;
    in obj // {
      streamSettings = (obj.streamSettings or {}) // {
        sockopt = (obj.streamSettings.sockopt or {}) // { mark = mark; };
      };
    };

    callAndApplyTagWithSoMark = mark: args: path: let
      obj = applyTag args path;
    in obj // {
      streamSettings = (obj.streamSettings or {}) // {
        sockopt = (obj.streamSettings.sockopt or {}) // { mark = mark; };
      };
    };
  in (importDir (applyTagAndSoMark 27) ./outbounds-misc)
    ++ (importDir (callAndApplyTagWithSoMark 27 { inherit config; }) ./outbounds-servers);
  routing = import ./routing { inherit applyTag importDir; };
  observatory = {
    subjectSelector = [ "wss" "us" "eu" ];
    probeURL = config.sops.placeholder."v2ray/observatory-probe-url";
    probeInterval = "30s";
  };
}
