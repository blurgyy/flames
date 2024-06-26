{ config, lib, ... }: let
  sops-key-file = "/var/lib/sops/nixos";
in {
  sops = {
    defaultSopsFile = ../../../${config.networking.hostName}/secrets.yaml;
    age.keyFile = sops-key-file;
    secrets = {
      "passwords/root".neededForUsers = true;
      "passwords/gy".neededForUsers = true;
      hostKey = {};
      acme-credentials-file = lib.mkIf config.services.haproxy-tailored.enable {
        sopsFile = ../../../_secrets.yaml;
        owner = config.users.users.haproxy.name;
        group = config.users.groups.haproxy.name;
      };
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = config.sops.secrets."passwords/root".path;
    users.gy = {
      hashedPasswordFile = config.sops.secrets."passwords/gy".path;
      isNormalUser = true;
    };
  };
  services.openssh.hostKeys = [{
    path = config.sops.secrets.hostKey.path;
    type = "ed25519";
  }];
}
