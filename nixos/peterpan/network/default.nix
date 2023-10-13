{ ... }: {
  imports = [
    ../../_parts/proxy-client-secrets.nix
  ];

  services.sing-box = {
    enableTailored = true;
    needProxyForZju = true;
  };
}
