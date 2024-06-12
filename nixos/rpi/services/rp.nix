{ config, ... }:

{
  services.proxy-zju = {
    enable = true;
    bindPort = 2096;
  };

  sops.secrets = {
    "sshrp/ssh-env" = {};
    "sshrp/acremote-env" = {};
    "sshrp/http-proxy-env" = {};
    "sshrp/socks-proxy-env" = {};
  };

  services.ssh-reverse-proxy = {
    client.instances = let
      identityFile = config.sops.secrets.hostKey.path;
    in {
      ssh = {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        bindPort = 10013;
        hostPort = builtins.head config.services.openssh.ports;
      };
      acremote = {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/acremote-env".path;
        bindPort = 21607;
        hostPort = config.services.acremote.port;
      };
      http-proxy = {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/http-proxy-env".path;
      };
      socks-proxy = {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/socks-proxy-env".path;
      };
    };
  };
}
