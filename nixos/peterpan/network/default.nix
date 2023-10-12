{ ... }: {
  imports = [
    ../../_parts/vclient.nix
  ];

  services.dcompass.enable = true;
}
