{ config, ... }: {
  sops.secrets = (import ./proxy-secrets.nix).server;
  services.v2ray-tailored.server.wsPath = config.sops.placeholder."v2ray/ws-path";
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [{
      name = "pivot-wss";
      condition = "if { path ${config.sops.placeholder."v2ray/ws-path"} }";
    }];
    backends = {
      pivot-wss = {
        mode = "tcp";
        server.address = "127.0.0.1:${config.services.v2ray-tailored.server.ports.wss}";
      };
    };
  };
}
