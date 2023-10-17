{ ... }: {
  imports = [
    ../../_parts/sing-box.nix
    ./wlan.nix
  ];

  systemd.network.wait-online.extraArgs = [ "--interface=wlan0" ];
}
