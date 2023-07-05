{ config, ... }: {
  sops.secrets."sshrp/ssh-env" = {};

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 10020;
        hostPort = builtins.head config.services.openssh.ports;
      };
    };
    server.services = {
      http-proxy-copy = {
        port = 1990;
        expose = false;
      };
      http-socks-proxy = {
        port = 1999;
        expose = false;
      };
      ssh-2x1080ti = {
        port = 13815;
        expose = false;
      };
      ssh-shared = {
        port = 22548;
        expose = false;
      };
    };
  };
}
