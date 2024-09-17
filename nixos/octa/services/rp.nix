{ config, ... }:

{
  services.ssh-reverse-proxy = {
    client.instances = let
      identityFile = config.sops.secrets.hostKey.path;
    in {
      rdp = {
        inherit identityFile;
        bindPort = 3389;
        hostPort = 3389;
      };
    };
  };
}
