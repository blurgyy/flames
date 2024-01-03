{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.warp-proxy;
in

{
  options.services.warp-proxy = {
    enable = mkEnableOption "Whether to enable cloudflare WARP in proxy mode";
    package = mkOption {
      type = types.package;
      default = pkgs.cloudflare-warp;
      description = "Should provide a systemd unit file warp-svc.service";
    };
    port = mkOption {
      type = types.int;
      default = 3856;
      description = "Socks4/5 proxy port";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.services.warp-svc = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        StateDirectory = "cloudflare-warp";
        WorkingDirectory = "/var/lib/${StateDirectory}";
        ExecStartPre = let
          settings = {  # transcribed from /var/lib/cloudflare-warp/settings.json
            version = 1;
            always_on = true;
            operation_mode.WarpProxy = null;
            proxy_port = cfg.port;
          };
          settingsJsonFile = pkgs.writeText "cloudflare-warp-settings.json" (builtins.toJSON settings);
        in "${pkgs.coreutils}/bin/ln -sf ${settingsJsonFile} /var/lib/${StateDirectory}/settings.json";
      };
    };
  };
}
