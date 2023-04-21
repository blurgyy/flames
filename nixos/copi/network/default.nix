{ ... }: {
  imports = [
    ./v2ray.nix
    ./rp.nix
    ./wlan.nix
  ];

  systemd.network.wait-online.extraArgs = [ "--interface=wlan0" ];
}
