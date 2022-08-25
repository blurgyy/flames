{ config, ... }: let
  sops-key-file = "/var/lib/${config.networking.hostName}.age";
  defaultSopsFile = ./secrets.yaml;
  age = {
    keyFile = sops-key-file;
    sshKeyPaths = [ ];  # Do not import ssh keys
  };
  gnupg.sshKeyPaths = [ ];  # Do not import ssh keys  
in {
  sops = {
    inherit defaultSopsFile age gnupg;
    secrets = {
      acme-credentials-file = { };
      "v2ray/ports/api" = { };
      "v2ray/ports/tcp" = { };
      "v2ray/ports/wss" = { };
      "v2ray/ws-path" = { };

      "v2ray/users/00/uuid" = {};
      "v2ray/users/01/uuid" = {};
      "v2ray/users/02/uuid" = {};
      "v2ray/users/03/uuid" = {};
      "v2ray/users/04/uuid" = {};
      "v2ray/users/05/uuid" = {};

      "v2ray/users/00/email" = {};
      "v2ray/users/01/email" = {};
      "v2ray/users/02/email" = {};
      "v2ray/users/03/email" = {};
      "v2ray/users/04/email" = {};
      "v2ray/users/05/email" = {};
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
}
