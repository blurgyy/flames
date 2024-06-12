{ config, ... }:

{
  services.proxy-zju = {
    enable = true;
    bindPort = 3096;
  };

  sops.secrets = {
    "sshrp/ssh-env" = {};
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
        bindPort = 2856;
        hostPort = builtins.head config.services.openssh.ports;
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
