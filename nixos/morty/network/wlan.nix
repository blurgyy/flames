{ config, ... }: {
  sops.secrets.wireless-environment-file = {};
  networking.wireless = {
    enable = true;
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@".psk = "@wlan_0_psk@";
      "@wlan_1@".psk = "@wlan_1_psk@";
      "@wlan_2@".psk = "@wlan_2_psk@";
      "@wlan_3@".psk = "@wlan_3_psk@";
      "@wlan_4@".psk = "@wlan_4_psk@";
      "@wlan_5@".psk = "@wlan_4_psk@";
      "@wlan_6@".psk = "@wlan_4_psk@";
      "@wlan_7@".psk = "@wlan_4_psk@";
      "ZJUWLAN".authProtocols = [ "NONE" ];
      "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
    };
  };
}
