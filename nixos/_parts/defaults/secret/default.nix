{ config, pkgs, ... }: let
  sops-key-file = "/var/lib/${config.networking.hostName}.age";
in {
  sops = {
    defaultSopsFile = ../../../${config.networking.hostName}/secrets.yaml;
    age.keyFile = sops-key-file;
    secrets = {
      "passwords/root".neededForUsers = true;
      "passwords/gy".neededForUsers = true;
      hostKey = {};
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
  users = let
    keys = import ../public-keys.nix;
  in {
    mutableUsers = false;
    groups.plocate = {};  # for plocate-updatedb.service
    users.root = {
      passwordFile = config.sops.secrets."passwords/root".path;
      openssh.authorizedKeys.keys = keys;
    };
    users.gy = {
      passwordFile = config.sops.secrets."passwords/gy".path;
      isNormalUser = true;
      extraGroups = [
        config.users.groups.keys.name 
        config.users.groups.wheel.name
        config.users.groups.video.name
        config.users.groups.plocate.name
        config.users.groups.dialout.name
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };
  };
  services.openssh.hostKeys = [{
    path = config.sops.secrets.hostKey.path;
    type = "ed25519";
  }];
}
