{ config, ... }: {
  sops.secrets.wireless-environment-file = {};
  networking.wireless = {
    enable = true;
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@" = { psk = "@wlan_0_psk@"; priority = 100; };
      "@wlan_1@" = { psk = "@wlan_1_psk@"; priority = 100; };
      "@wlan_2@" = { psk = "@wlan_2_psk@"; priority = 75; };
      "@wlan_3@" = { psk = "@wlan_3_psk@"; priority = 50; };
      "@wlan_4@" = { psk = "@wlan_4_psk@"; priority = 30; };
      "@wlan_5@" = { psk = "@wlan_5_psk@"; priority = 30; };
    };
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
