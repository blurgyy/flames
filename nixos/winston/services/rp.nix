{ config, ... }: {
  sops.secrets = {
    "sshrp/ssh-env" = {};
    "sshrp/ssh-jammy-env" = {};
  };

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 10020;
        hostPort = builtins.head config.services.openssh.ports;
      };
      ssh-jammy = {
        environmentFile = config.sops.secrets."sshrp/ssh-jammy-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 16251;
        hostPort = 1722;
      };
    };
    server.services = {
      http-proxy-from-copi = {
        port = 2990;
        expose = false;
      };
      socks-proxy-from-copi = {
        port = 2999;
        expose = false;
      };
      ssh-2x1080ti = {
        port = 13815;
        # expose = false;
        # somehow wired connection from ZJU are not in the private range (e.g. they are in
        # 210.0.0.0/8) and this machine is shared out to them
        expose = true;
      };
      ssh-shared = {
        port = 22548;
        expose = false;
      };
      ssh-mono = {
        port = 17266;
        expose = false;
      };
    };
  };

  services.haproxy-tailored = {
    enable = true;
    frontends = {
      http-proxy = {
        mode = "http";
        alpns = [ "h3" "h2" "http/1.1" ];
        binds = [ "*:1990" ];
        backends = [ { name = "http-proxy-balancer"; isDefault = true; } ];
      };
      socks-proxy = {
        mode = "tcp";
        binds = [ "*:1999" ];
        backends = [ { name = "socks-proxy-balancer"; isDefault = true; } ];
      };
    };
    backends = {
      http-proxy-balancer = {
        mode = "http";
        balancer = "roundrobin";
        servers = [{ address = "127.0.0.1:2990"; } { address = "127.0.0.1:9990"; }];
      };
      socks-proxy-balancer = {
        mode = "tcp";
        balancer = "roundrobin";
        servers = [{ address = "127.0.0.1:2999"; } { address = "127.0.0.1:9999"; }];
      };
    };
  };
}
