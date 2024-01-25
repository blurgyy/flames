{ config, ... }: {
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
}
