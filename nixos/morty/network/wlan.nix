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
      "ext:wlan_0" = { pskRaw = "ext:wlan_0_psk"; priority = 90; };
      "ext:wlan_1" = { pskRaw = "ext:wlan_1_psk"; priority = 90; };
      "ext:wlan_2" = { pskRaw = "ext:wlan_2_psk"; priority = 90; };
      "ext:wlan_3" = { pskRaw = "ext:wlan_3_psk"; priority = 65; };
      "ext:wlan_4" = { pskRaw = "ext:wlan_4_psk"; priority = 65; };
      "ext:wlan_5" = { pskRaw = "ext:wlan_5_psk"; priority = 40; };
      "ext:wlan_6" = { pskRaw = "ext:wlan_6_psk"; priority = 20; };
      "ext:wlan_7" = { pskRaw = "ext:wlan_7_psk"; priority = 20; };
      "ext:wlan_8" = { pskRaw = "ext:wlan_8_psk"; priority = 20; };
      "ext:wlan_9" = { pskRaw = "ext:wlan_9_psk"; priority = 20; };
    };
  };

  sops.secrets."zjuwlan-credentials".sopsFile = sharedSecretsFile;
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };
}
