{ config, ... }: {
  sops.secrets."sshrp/ssh-env" = {};

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 6229;
        hostPort = builtins.head config.services.openssh.ports;
      };
    };
  };
}