{ config, pkgs, ... }: {
  sops.secrets = {
    "sshrp/ssh-env" = {};
    "sshrp/http-proxy-env" = {};
    "sshrp/socks-proxy-env" = {};
  };

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 10021;
        hostPort = builtins.head config.services.openssh.ports;
      };
      http-proxy = {
        environmentFile = config.sops.secrets."sshrp/http-proxy-env".path;
        identityFile = config.sops.secrets.hostKey.path;
      };
      socks-proxy = {
        environmentFile = config.sops.secrets."sshrp/socks-proxy-env".path;
        identityFile = config.sops.secrets.hostKey.path;
      };
    };
  };

  systemd.services = let
    ExecCondition = pkgs.writeShellScript "is-connected-to-zjuwlan" ''
      function current_ssid() {
        iw dev | grep ssid | grep ZJU | cut -d' ' -f2
      }
      if ! cmp -s <(current_ssid | head -c3) <(echo -n ZJU); then
        echo "not connected to ZJUWLAN, skipping"
        exit 1
      fi
    '';
  in {
    rp-http-proxy.serviceConfig = { inherit ExecCondition; };
    rp-socks-proxy.serviceConfig = { inherit ExecCondition; };
  };
}
