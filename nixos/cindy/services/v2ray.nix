{ config, ... }: {
  imports = [
    ../../_parts/vserver.nix
  ];
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [
      { name = "pivot"; condition = "unless HTTP"; }
      { name = "pivot-wss"; condition = "if { path ${config.sops.placeholder."v2ray/ws-path"} }"; }
    ];
    backends = {
      pivot = {
        mode = "tcp";
        server.address = "127.0.0.1:${config.services.v2ray-tailored.server.ports.tcp}";
      };
      pivot-wss = {
        mode = "tcp";
        server.address = "127.0.0.1:${config.services.v2ray-tailored.server.ports.wss}";
      };
    };
  };
}
