{ config, ... }: {
  imports = [ ../../_parts/vserver.nix ];
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [{ name = "pivot"; condition = "unless HTTP"; }];
    backends.pivot = {
      mode = "tcp";
      server.address = "127.0.0.1:${config.services.v2ray-tailored.server.ports.tcp}";
    };
  };
}
