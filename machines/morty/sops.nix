{ config, ... }: let
  sops-key-file = "/var/lib/${config.networking.hostName}.age";
in {
  users.users = {
    root.passwordFile = config.sops.secrets."passwords/root".path;
    gy = {
      passwordFile = config.sops.secrets."passwords/gy".path;
      extraGroups = [ config.users.groups.keys.name ];
    };
  };
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = sops-key-file;
      sshKeyPaths = [ ];  # Do not import ssh keys
    };
    gnupg.sshKeyPaths = [ ];  # Do not import ssh keys  
    secrets = {
      "passwords/root".neededForUsers = true;
      "passwords/gy".neededForUsers = true;
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
}
