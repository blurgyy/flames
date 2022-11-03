{ config, lib, ... }: {
  services.haproxy-tailored = {
    enable = lib.mkDefault false;
    frontends = {
      http-in = {
        mode = "http";
        binds = [ "*:80" ];
        alpns = [ "http/1.1" ];
        requestRules = [ "redirect scheme https code 301 unless { ssl_fc }" ];
      };
      tls-in = {
        mode = "tcp";
        binds = [ "*:443" ];
        alpns = [ "h3" "h2" "http/1.1" ];
        requestRules = [
          "inspect-delay 5s"
          "content accept if { req_ssl_hello_type 1 }"
        ];
        backends = [
          { name = "tls-offload-back"; isDefault = true; }
        ];
      };
      tls-offload-front = {
        mode = "tcp";
        binds = [ "/run/haproxy/tls-offload.sock" ];
        alpns = [ "http/1.1" ];
        domain.name= lib.mkDefault config.networking.fqdn;
        acceptProxy = true;
        requestRules = [
          "inspect-delay 5s"
          "content accept if { req_ssl_hello_type 1 }"
        ];
      };
    };
    backends = {
      tls-offload-back = {
        mode = "tcp";
        server = {
          address = "/run/haproxy/tls-offload.sock";
          extraArgs = [ "send-proxy-v2" ];
        };
      };
    };
  };
}
