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
      description = "
        Socks4/5 proxy port, if socks5 (socks5h://) is not working, it's mostly likely due to
        the DNS used by warp-svc (cloudflare-dns.com) not working.  A workaround is to not delegate
        DNS request to the socks proxy by using socks4 (socks4://).
      ";
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
        ExecStartPre = "${pkgs.make-warp-settings-json}/bin/make-warp-settings-json ${toString cfg.port} /var/lib/${StateDirectory}/settings.json";
        LogNamespace = "noisy";
        RestartSec = 5;
        Restart = "always";
      };
    };
  };
}
