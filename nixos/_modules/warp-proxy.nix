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
        ExecStartPre = let
          settings = {  # transcribed from /var/lib/cloudflare-warp/settings.json
            version = 1;
            always_on = true;
            operation_mode.WarpProxy = null;
            proxy_port = cfg.port;
            # WARP uses 162.159.192.0/24 as endpoints, the default endpoint configured at
            # /var/lib/cloudflare-warp/conf.json is 162.159.192.9, which cannot seem to be able to
            # ping from all machines.  This address can ping.  This can be imperically set using
            # `warp-cli set-custom-endpoint 162.159.192.254:2408`.
            # NOTE:
            #   * Although the default configured endpoints are written to
            #     /var/lib/cloudflare-warp/conf.json, the file is overwritten on start of warp-svc.
            #   * The default configured endpoints seem to change from machines to machines.
            # TODO:
            #   Maybe write a script to determine a reachable endpoint at ExecStartPre.
            # REF:
            #   * <https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/deployment/firewall#warp-ingress-ip>
            #   * <https://ping.pe/162.159.192.9>
            override_warp_endpoint = "162.159.192.254:2408";
          };
          settingsJsonFile = pkgs.writeText "cloudflare-warp-settings.json" (builtins.toJSON settings);
        in "${pkgs.coreutils}/bin/ln -sf ${settingsJsonFile} /var/lib/${StateDirectory}/settings.json";
      };
    };
  };
}
