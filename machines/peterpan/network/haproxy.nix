{ config }: let
  domainName = "${config.networking.fqdn}";
in {
  enable = true;
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
      alpns = [ "h2" "http/1.1" ];
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
      acceptProxy = true;
      domain = {
        name = domainName;
        acme.enable = false;
      };
      requestRules = [
        "inspect-delay 5s"
        "content accept if { req_ssl_hello_type 1 }"
      ];
      backends = [
        { name = "web"; condition = "if HTTP"; }
        { name = "pivot"; condition = "if !HTTP"; }
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
    web = { mode = "http"; server.address = "127.0.0.1:8080"; };
    pivot = { mode = "tcp"; server.address = "127.0.0.1:65092"; };
  };
}
