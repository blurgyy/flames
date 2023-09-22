{ config, ... }: {
  services = {
    ntfy-tailored = {
      enable = true;
      domain = "ntfy.blurgy.xyz";
    };
    haproxy-tailored = {
      frontends.tls-offload-front.backends = [
        { name = "ntfy-default"; isDefault = true; }
      ];
      backends.ntfy-default = {
        mode = "http";
        server.address = "127.0.0.1:${toString config.services.ntfy-tailored.port}";
      };
    };
  };
}
