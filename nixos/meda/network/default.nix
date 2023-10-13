{ ... }: {
  imports = [
    ../../_parts/proxy-client-secrets.nix
    ./wsl.nix
  ];

  services.sing-box = {
    enableTailored = true;
    needProxyForZju = true;
  };
}
