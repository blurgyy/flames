{ ... }: {
  imports = [
    ./hydra.nix
    ./rathole.nix
    ./soft-serve.nix
    ./v2ray.nix
  ];
  services.haproxy-tailored = {
    enable = true;
    frontends.tls-offload-front.domain.acme.enable = false;
  };
}
