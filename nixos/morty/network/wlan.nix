{ config, ... }:

let
  sharedSecretsFile = ../../_secrets.yaml;
in

{
  sops.secrets.wireless-environment-file.sopsFile = sharedSecretsFile;
  networking.wireless = {
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@" = { psk = "@wlan_0_psk@"; priority = 90; };
      "@wlan_1@" = { psk = "@wlan_1_psk@"; priority = 90; };
      "@wlan_2@" = { psk = "@wlan_2_psk@"; priority = 90; };
      "@wlan_3@" = { psk = "@wlan_3_psk@"; priority = 65; };
      "@wlan_4@" = { psk = "@wlan_4_psk@"; priority = 65; };
      "@wlan_5@" = { psk = "@wlan_5_psk@"; priority = 40; };
      "@wlan_6@" = { psk = "@wlan_6_psk@"; priority = 20; };
      "@wlan_7@" = { psk = "@wlan_7_psk@"; priority = 20; };
      "@wlan_8@" = { psk = "@wlan_8_psk@"; priority = 20; };
      "@wlan_9@" = { psk = "@wlan_9_psk@"; priority = 20; };
    };
  };

  sops.secrets."zjuwlan-credentials".sopsFile = sharedSecretsFile;
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };
}
