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

  systemd.network.networks."40-wlan0".linkConfig.RequiredForOnline = true;

  sops.secrets."zjuwlan-credentials".sopsFile = sharedSecretsFile;
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };

  networking.reboot-on-network-failure.enable = true;
}
