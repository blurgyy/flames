{ config }: {
  enable = true;
  frontends = [
    {
      name = "http-in";
      mode = "http";
      binds = [ "*:80" ];
      alpns = [ "http/1.1" ];
      requestRules = [ "redirect scheme https code 301 unless { ssl_fc }" ];
    }
    {
      name = "tls-in";
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
    }
    {
      name = "tls-offload-front";
      mode = "tcp";
      binds = [ "/run/haproxy/tls-offload.sock" ];
      alpns = [ "http/1.1" ];
      acceptProxy = true;
      domain = {
        name = "cube.blurgy.xyz";
        acme = {
          enable = true;
          email = "gy@blurgy.xyz";
          credentialsFile = config.sops.secrets.acme-credentials-file.path;
        };
      };
      requestRules = [
        "inspect-delay 5s"
        "content accept if { req_ssl_hello_type 1 }"
      ];
    }
  ];
  backends = [
    {
      name = "tls-offload-back";
      mode = "tcp";
      server = {
        address = "/run/haproxy/tls-offload.sock";
        extraArgs = [ "send-proxy-v2" ];
      };
    }
  ];
}
