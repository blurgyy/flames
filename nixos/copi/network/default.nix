{ ... }: {
  imports = [
    ../../_parts/vclient.nix
    ./rp.nix
    ./wlan.nix
  ];

  services.dcompass.enable = true;

  systemd.network.wait-online.extraArgs = [ "--interface=wlan0" ];
}
