{ config, pkgs, ... }: {
  imports = [
    ../../_parts/sing-box.nix
    ./wlan.nix
  ];

  sops.secrets = {
    "zjuwlan-credentials" = {};
    "ap-password" = {};
  };

  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };

  networking.wireless.interfaces = [ "wlan0_sta" ];
  networking.wlanInterfaces = {
    wlan0_sta.device = "wlan0";
    wlan0_ap.device = "wlan0";
  };
  systemd.network.networks."40-wlan0_sta" = {
    name = "wlan0_sta";
    networkConfig.DHCP = "yes";
  };
  networking.ap = {
    enable = false;
    apInterface = "wlan0_ap";
    destinationInterface = "wlan0_sta";
    address = "192.168.169.1/24";
    dnsAddress = config.services.sing-box.tunDnsAddress;
    passwordFile = config.sops.secrets."ap-password".path;
  };

  systemd.services.hp-keycodes = {
    wantedBy = [
      "multi-user.target"
      "rescue.target"
      "graphical.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      # REF: <https://itectec.com/ubuntu/ubuntu-does-airplane-mode-keep-toggling-on-the-hp-laptop-in-ubuntu-18-04/>
      ExecStart = "${pkgs.kbd}/bin/setkeycodes e057 240 e058 240";
    };
  };
}
