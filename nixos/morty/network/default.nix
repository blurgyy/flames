{ config, pkgs, ... }: {
  imports = [
    ../../_parts/sing-box.nix
    ./wlan.nix
  ];

  systemd.network.wait-online.anyInterface = true;
  sops.secrets."zjuwlan-credentials" = {};
  networking.zjuwlan-autoconnect = {
    enable = true;
    credentialsFile = config.sops.secrets."zjuwlan-credentials".path;
  };

  systemd.network.networks."40-eth0".linkConfig.RequiredForOnline = false;
  systemd.network.networks."40-wlan0".linkConfig.RequiredForOnline = true;

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
