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

  networking.interfaces = let
    fixedSingleIpv4Address = [{
        address = "192.168.3.169";
        prefixLength = 24;
      }];
  in {
    wlo1.ipv4.addresses = fixedSingleIpv4Address;
    wlan0.ipv4.addresses = fixedSingleIpv4Address;
  };
}
