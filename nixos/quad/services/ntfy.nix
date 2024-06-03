{ config, ... }: {
  services = {
    ntfy-tailored = {
      enable = true;
      domain = "ntfy.blurgy.xyz";
    };
    haproxy-tailored = {
      frontends.tls-offload-front = {
        acls = [ { name = "is_ntfy"; body = "hdr(host) -i ${config.networking.fqdn}"; } ];
        backends = [ { name = "ntfy"; condition = "if is_ntfy"; } ];
      };
      backends.ntfy-default = {
        mode = "http";
        server.address = "127.0.0.1:${toString config.services.ntfy-tailored.port}";
      };
    };
  };
}
