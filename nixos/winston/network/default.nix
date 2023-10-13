{ ... }: {
  imports = [
    ../../_parts/proxy-client-secrets.nix
    ./cable.nix
    ./rp.nix
  ];

  services.sing-box = {
    enableTailored = true;
    needProxyForZju = false;
  };
}
