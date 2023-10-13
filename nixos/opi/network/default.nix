{ ... }: {
  imports = [
    ../../_parts/proxy-client-secrets.nix
    ./rp.nix
    ./wlan.nix
  ];

  services.sing-box = {
    enable = true;
    preConfigure = true;
    needProxyForZju = true;
  };

  systemd.network.wait-online.extraArgs = [ "--interface=wlan0" ];
}
