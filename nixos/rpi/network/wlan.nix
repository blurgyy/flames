{ config, ... }: {
  sops.secrets.wireless-environment-file = {};
  networking.wireless = {
    enable = true;
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@".psk = "@wlan_0_psk@";
      "@wlan_1@".psk = "@wlan_1_psk@";
      "@wlan_2@".psk = "@wlan_2_psk@";
    };
  };
}
