{ config, ... }: {
  sops.secrets."sshrp/ssh-env" = {};

  services.ssh-reverse-proxy = {
    instances = [{
      name = "ssh";
      environmentFile = config.sops.secrets."sshrp/ssh-env".path;
      identityFile = config.sops.secrets.hostKey.path;
      bindPort = 10021;
      hostPort = builtins.head config.services.openssh.ports;
    }];
  };
}
