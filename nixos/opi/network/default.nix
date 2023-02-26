{ ... }: {
  imports = [
    ../../_parts/vclient.nix
    ./rp.nix
    ./wlan.nix
  ];

  systemd.network.wait-online.extraArgs = [ "--interface=wlan0" ];
}
