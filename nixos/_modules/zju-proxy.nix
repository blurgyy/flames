{ config, lib, pkgs, ... }:

let
  proxy-zju-host-port = 8952;
  cfg = config.services.proxy-zju;
in

{
  options = {
    services.proxy-zju = with lib; {
      enable = mkEnableOption ''
        Whether to enable pivot server that proxies traffic to ZJU internal network
      '';
      bindPort = mkOption {
        type = types.int;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "sshrp/proxy-zju-env" = {};
    } // (import ../_parts/proxy-secrets.nix).server;

    services.ssh-reverse-proxy = {
      client.instances = {
        proxy-zju = {
          identityFile = config.sops.secrets.hostKey.path;
          environmentFile = config.sops.secrets."sshrp/proxy-zju-env".path;
          inherit (cfg) bindPort;
          hostPort = proxy-zju-host-port;
        };
      };
    };

    services.sing-box.enable = true;
    services.sing-box.settings = let
      inboundTag = "zju-proxy-in";
    in {
      inbounds = [{
        tag = inboundTag;

        type = "vmess";
        listen = "127.0.0.1";
        listen_port = proxy-zju-host-port;
        users = map
          (index: {
            name._secret = config.sops.secrets."v2ray/users/${index}/email".path;
            uuid._secret = config.sops.secrets."v2ray/users/${index}/uuid".path;
          })
          [ "00" "01" "02" "03" "04" "05" "06" "07" "08" ];
      }];
      route.rules = lib.mkBefore [{  # user mkBefore to prioritize this direct rule
        inbound = inboundTag;
        outbound = "direct-zju-internal";
      } {
        domain_suffix = "@custom/25-zju-domain-suffix@";
        domain_keyword = "@custom/25-zju-domain-keyword@";
        ip_cidr = "@custom/25-zju-ip@";
        outbound = "direct-zju-internal";
      }];
    };

    systemd.services = let
      ExecCondition = pkgs.writeShellScript "is-connected-to-zjuwlan" ''
        function current_ssid() {
          iw dev | grep ssid | grep ZJU | cut -d' ' -f2
        }
        if ! cmp -s <(current_ssid | head -c3) <(echo -n ZJU); then
          echo >&2 "not connected to ZJUWLAN, skipping"
          exit 1
        else
          echo "connected to ZJUWLAN"
        fi
      '';
      path = with pkgs; [ iw diffutils gnugrep coreutils];
    in {
      rp-http-proxy = {
        inherit path;
        serviceConfig = { inherit ExecCondition; };
      };
      rp-socks-proxy = {
        inherit path;
        serviceConfig = { inherit ExecCondition; };
      };
    };

    systemd.timers = let
      wantedBy = [ "timers.target" ];
      sharedTimerConfig = {
        OnCalendar = "*-*-* *:*:00";  # minutely
        Persistent = "yes";
      };
    in {
      rp-http-proxy = {
        inherit wantedBy;
        timerConfig = sharedTimerConfig // {
          Unit = "rp-http-proxy.service";
        };
      };
      rp-socks-proxy = {
        inherit wantedBy;
        timerConfig = sharedTimerConfig // {
          Unit = "rp-socks-proxy.service";
        };
      };
    };
  };
}
