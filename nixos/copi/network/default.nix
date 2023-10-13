{ ... }: {
  imports = [
    ../../_parts/sing-box.nix
    ./rp.nix
    ./wlan.nix
  ];

  systemd.network.wait-online.extraArgs = [ "--interface=wlan0" ];
}
