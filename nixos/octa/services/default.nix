{ ... }: {
  imports = [
    ../../_parts/distributed-builder.nix
    ./vm.nix
  ];
  services.haproxy-tailored = {
    enable = true;
    frontends.tls-offload-front.domain.acme.enable = false;
  };
}
