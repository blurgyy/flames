{ config, ... }: {
  sops.secrets = {
    "sshrp/ssh-env" = {};
    "sshrp/mixed-proxy-env" = {};
  };

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 2856;
        hostPort = builtins.head config.services.openssh.ports;
      };
      mixed-proxy = {
        environmentFile = config.sops.secrets."sshrp/mixed-proxy-env".path;
        identityFile = config.sops.secrets.hostKey.path;
      };
    };
  };
}
