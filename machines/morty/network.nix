{ config, lib, pkgs, ... }: {
  sops.secrets = {
    wireless-environment-file = {};

    "v2ray/observatory-probe-url" = {};
    "v2ray/ports/http" = {};
    "v2ray/ports/socks" = {};
    "v2ray/ports/tproxy" = {};
    "v2ray/ws-path" = {};
    "v2ray/id" = {};
    "v2ray/domains/eu-00" = {};
    "v2ray/domains/hk-00" = {};
    "v2ray/domains/us-00" = {};
    "v2ray/domains/wss-eu-00" = {};
    "v2ray/domains/wss-us-00" = {};
    "v2ray/addresses/cn-00" = {};
    "v2ray/addresses/eu-00" = {};
    "v2ray/addresses/hk-00" = {};
    "v2ray/addresses/us-00" = {};

    "rathole/remote_addr" = {};
    "rathole/ssh/token" = {};
  };
  networking.wireless = {
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@".psk = "@wlan_0_psk@";
      "@wlan_1@".psk = "@wlan_1_psk@";
      "@wlan_2@".psk = "@wlan_2_psk@";
      "@wlan_3@".psk = "@wlan_3_psk@";
      "@wlan_4@".psk = "@wlan_4_psk@";
    };
  };
  services.v2ray-tailored = {
    client = (import ../_parts/v2ray.nix { inherit config; }).client;
  };
  services.rathole = {
    enable = true;
    client = {
      remoteAddr = config.sops.placeholder."rathole/remote_addr";
      services = [
        {
          name = "ssh-${config.networking.hostName}";
          token = config.sops.placeholder."rathole/ssh/token";
          localAddr = "127.1:22";
        }
      ];
    };
  };
}
