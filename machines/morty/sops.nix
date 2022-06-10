{ config, ... }: {
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
    };
  };

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age = {
      keyFile = "/var/lib/sops.age";
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

      "v2ray/users/a/id" = { };

      "v2ray/domains/eu-00" = { };
      "v2ray/domains/us-00" = { };
      "v2ray/domains/wss-eu-00" = { };
      "v2ray/domains/wss-us-00" = { };

      "server-addresses/cn-00" = { };
      "server-addresses/eu-00" = { };
      "server-addresses/us-00" = { };

      "server-addresses/cindy" = { };
      "server-addresses/hooper" = { };
      "server-addresses/peterpan" = { };
      "server-addresses/watson" = { };

      "ports/rathole/data-channel" = { };
      "ports/rathole/morty/ssh" = { };
      "ports/rathole/rpi/ssh" = { };
      "ports/rathole/rpi/acremote" = { };
      "ports/rathole/watson/ssh" = { };
      "ports/rathole/watson/coderp" = { };
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = "/var/lib/sops.age";
}
