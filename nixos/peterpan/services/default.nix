{ config, ... }: {
  imports = [
    ./rathole.nix
    ./soft-serve.nix
    ./v2ray.nix
  ];
  services.haproxy-tailored = {
    enable = true;
    frontends.tls-offload-front = {
      domain.acme.enable = false;
      backends = [
        { name = "web"; condition = "if HTTP"; }
        { name = "v2ray"; condition = "if !HTTP"; }
      ];
    };
  };
}
