{ ... }: {
  imports = [
    ../../_parts/proxy-client-secrets.nix
  ];

  services.sing-box = {
    enable = true;
    preConfigure = true;
  };
}
