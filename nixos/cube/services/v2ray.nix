{ config, ... }: {
  imports = [ ../../_parts/vserver.nix ];
  services.haproxy-tailored.backends.v2ray = {
    mode = "tcp";
    server.address = "127.0.0.1:${toString config.services.v2ray-tailored.server.ports.tcp}";
  };
}
