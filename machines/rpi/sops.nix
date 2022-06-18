{ config, ... }: let
  sops-key-file = "/var/lib/${config.networking.hostName}.age";
in {
  users.users.root.passwordFile = config.sops.secrets."passwords/root".path;
  networking.wireless = {
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@".psk = "@wlan_0_psk@";
      "@wlan_1@".psk = "@wlan_1_psk@";
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
      wireless-environment-file = { };
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
}
