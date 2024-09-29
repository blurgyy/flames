{ config, ... }:

let
  sharedSecretsFile = ../../_secrets.yaml;
in

{
  sops.secrets.imperative-wireless-networks-file = {
    sopsFile = sharedSecretsFile;
    path = "/etc/wpa_supplicant.conf";
  };

  networking.wireless = {
    enable = true;
    allowAuxiliaryImperativeNetworks = true;
  };

  sops.secrets."zjuwlan-credentials".sopsFile = sharedSecretsFile;
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };
}
