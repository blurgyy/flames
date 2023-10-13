{ ... }: {
  imports = [
    ../../_parts/proxy-client-secrets.nix
    ./wsl.nix
  ];

  services.sing-box = {
    enable = true;
    preConfigure = true;
    needProxyForZju = true;
  };
}
