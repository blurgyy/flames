{ config, ... }: let
  sops-key-file = "/var/lib/${config.networking.hostName}.age";
in {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = sops-key-file;
      sshKeyPaths = [];  # Do not import ssh keys
    };
    gnupg.sshKeyPaths = [];
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
}
