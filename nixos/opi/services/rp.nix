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
    server.services = {
      wisp-rdp = {
        port = 3389;
        expose = false;
      };
      wisp-vnc = {
        port = 5900;
        expose = false;
      };
    };
  };
}
