{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dcompass;
in

{
  options.services.dcompass = {
    enable = mkEnableOption "Whether to use dcompass as system's DNS resolver";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dcompass.dcompass-cn ];

    services.resolved.enable = false;
    systemd.services.dcompass = let
      dcompassCfg =
        pkgs.writeText "dcompass.json"
          (builtins.toJSON
            (import ./config.nix { inherit pkgs; })
          );
    in {
      documentation = [ "https://github.com/compassd/dcompass" ];
      path = [ pkgs.dcompass.dcompass-cn ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 5;
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        LogNamespace = "noisy";
      };
      preStart = "dcompass --validate --config=${dcompassCfg}";
      script = "dcompass --config=${dcompassCfg}";
    };

    # services.v2ray-tailored.client.transparentProxying.proxiedSystemServices = [ "dcompass.service" ];
  };
}
