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
      "ZJUWLAN".authProtocols = [ "NONE" ];
      "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
    };
  };
  networking = {
    defaultGateway = "192.168.0.1";
    interfaces.wlan0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.0.169";
        prefixLength = 24;
      }];
    };
  };
}
