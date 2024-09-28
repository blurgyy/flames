{ config, ... }:

let
  sharedSecretsFile = ../../_secrets.yaml;
in

{
  sops.secrets.wireless-environment-file.sopsFile = sharedSecretsFile;
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "morty.ap" = {
        psk = "ext:morty_ap_psk";
        priority = 100;
        # REF: <https://wiki.archlinux.org/title/wpa_supplicant#Connections_to_mixed_WPA2-PSK/WPA3-SAE_access_points>
        authProtocols = [ "WPA-PSK-SHA256" ];
        extraConfig = ''
          ieee80211w=2
        '';
      };
      "ext:wlan_0" = { pskRaw = "ext:wlan_0_psk"; priority = 90; };
      "ext:wlan_1" = { pskRaw = "ext:wlan_1_psk"; priority = 90; };
      "ext:wlan_2" = { pskRaw = "ext:wlan_2_psk"; priority = 90; };
      "ext:wlan_3" = { pskRaw = "ext:wlan_3_psk"; priority = 65; };
      "ext:wlan_4" = { pskRaw = "ext:wlan_4_psk"; priority = 65; };
      "ext:wlan_5" = { pskRaw = "ext:wlan_5_psk"; priority = 40; };
      "ext:wlan_6" = { pskRaw = "ext:wlan_6_psk"; priority = 20; };
      "ext:wlan_7" = { pskRaw = "ext:wlan_7_psk"; priority = 20; };
    };
  };

  systemd.network.networks."40-wlan0".linkConfig.RequiredForOnline = true;

  sops.secrets."zjuwlan-credentials".sopsFile = sharedSecretsFile;
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };

  networking.reboot-on-network-failure.enable = true;
}
