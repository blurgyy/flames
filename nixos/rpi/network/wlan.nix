{ config, ... }: {
  sops.secrets.wireless-environment-file = {};
  networking.wireless = {
    enable = true;
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "morty.ap" = {
        psk = "@morty_ap_psk@";
        priority = 100;
        # REF: <https://wiki.archlinux.org/title/wpa_supplicant#Connections_to_mixed_WPA2-PSK/WPA3-SAE_access_points>
        authProtocols = [ "WPA-PSK-SHA256" ];
        extraConfig = ''
          ieee80211w=2
        '';
      };
      "@wlan_0@" = { psk = "@wlan_0_psk@"; priority = 100; };
      "@wlan_1@" = { psk = "@wlan_1_psk@"; priority = 100; };
      "@wlan_2@" = { psk = "@wlan_2_psk@"; priority = 100; };
      "@wlan_3@" = { psk = "@wlan_3_psk@"; priority = 75; };
      "@wlan_4@" = { psk = "@wlan_4_psk@"; priority = 75; };
      "@wlan_5@" = { psk = "@wlan_5_psk@"; priority = 50; };
      "@wlan_6@" = { psk = "@wlan_6_psk@"; priority = 30; };
      "@wlan_7@" = { psk = "@wlan_7_psk@"; priority = 30; };
      "ZJUWLAN".authProtocols = [ "NONE" ];
      "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
    };
  };

  systemd.network.networks."40-wlan0".linkConfig.RequiredForOnline = true;

  sops.secrets."zjuwlan-credentials" = {};
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };

  networking.reboot-on-network-failure = true;
}
