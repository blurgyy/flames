{ ... }: {
  imports = [
    ../../_parts/vclient.nix
    ./cable.nix
    ./rp.nix
  ];

  services.dcompass.enable = true;
}
