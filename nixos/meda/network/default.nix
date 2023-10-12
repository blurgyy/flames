{ ... }: {
  imports = [
    ./wsl.nix
    ../../_parts/vclient.nix
  ];

  services.dcompass.enable = true;
}
