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
  networking.wireless = {
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@".psk = "@wlan_0_psk@";
      "@wlan_1@".psk = "@wlan_1_psk@";
      "@wlan_2@".psk = "@wlan_2_psk@";
      "@wlan_3@".psk = "@wlan_3_psk@";
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

      wireless-environment-file = { };

      "v2ray/observatory-probe-url" = { };
      "v2ray/ports/http" = { };
      "v2ray/ports/socks" = { };
      "v2ray/ports/tproxy" = { };
      "v2ray/ws-path" = { };
      "v2ray/id" = { };
      "v2ray/domains/eu-00" = { };
      "v2ray/domains/us-00" = { };
      "v2ray/domains/wss-eu-00" = { };
      "v2ray/domains/wss-us-00" = { };
      "v2ray/addresses/cn-00" = { };
      "v2ray/addresses/eu-00" = { };
      "v2ray/addresses/us-00" = { };

      "server-addresses/cindy" = { };
      "server-addresses/hooper" = { };
      "server-addresses/peterpan" = { };
      "server-addresses/watson" = { };

      "rathole/remote_addr" = { };
      "rathole/ssh/token" = { };
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
}
