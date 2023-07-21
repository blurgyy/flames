{ ... }: {
  imports = [
    ../../_parts/distributed-builder.nix
    ./rp.nix
    ./soft-serve.nix
    ./v2ray.nix
  ];
  services.haproxy-tailored = {
    enable = true;
    frontends.tls-offload-front.domain.acme.enable = false;
  };
}
