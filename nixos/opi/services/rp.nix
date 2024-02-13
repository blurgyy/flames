{ config, ... }: {
  sops.secrets = {
    "sshrp/ssh-env" = {};
    "sshrp/wisp-rdp" = {};
    "sshrp/wisp-vnc" = {};
  };

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 6229;
        hostPort = builtins.head config.services.openssh.ports;
      };

      # local forwards
      wisp-rdp = {
        type = "local";
        environmentFile = config.sops.secrets."sshrp/wisp-rdp".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 3389;
        hostPort = 3389;
      };
      wisp-vnc = {
        type = "local";
        environmentFile = config.sops.secrets."sshrp/wisp-vnc".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 5900;
        hostPort = 5900;
      };
    };
  };
}
