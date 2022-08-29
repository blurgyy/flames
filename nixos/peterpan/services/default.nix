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
        { name = "pivot"; condition = "if !HTTP"; }
      ];
    };
    backends = {
      web = { mode = "http"; server.address = "127.0.0.1:8080"; };
      pivot = { mode = "tcp"; server.address = "127.0.0.1:65092"; };
    };
  };
}
