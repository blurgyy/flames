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
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
}
