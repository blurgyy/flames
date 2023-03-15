{ config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.dcompass.dcompass-cn ];

  systemd.services.dcompass = let
    dcompassCfg =
      pkgs.writeText "dcompass.json"
        (builtins.toJSON
          (import ./config.nix { inherit pkgs; })
        );
  in {
    documentation = [ "https://github.com/compassd/dcompass" ];
    path = [ pkgs.dcompass.dcompass-cn ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    };
    preStart = "dcompass --validate --config=${dcompassCfg}";
    script = "dcompass --config=${dcompassCfg}";
  };
}
