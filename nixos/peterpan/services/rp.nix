{ config, ... }: {
  services.ssh-reverse-proxy.server = {
    services = {
      ssh-morty = {
        port = 10021;
        expose = true;
      };
      ssh-copi = {
        port = 2856;
        expose = true;
      };
      ssh-opi = {
        port = 6229;
        expose = true;
      };
      ssh-rpi = {
        port = 10013;
        expose = true;
      };
      ssh-winston = {
        port = 10020;
        expose = true;
      };
      ssh-2x1080ti = {
        port = 10023;
        expose = true;
      };
      ssh-shared = {
        port = 10025;
        expose = true;
      };

      acremote-rpi = {
        port = 21607;
        expose = true;
      };
      coderp-watson.port = 1111;
    };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [ { name = "web"; condition = "if { path_beg /zju/ }"; } ];
    backends.web = {
      mode = "http";
      requestRules = [ "replace-uri /zju(.*)$ \\1" ];
      server.address = "127.0.0.1:${toString config.services.ssh-reverse-proxy.server.services.coderp-watson.port}";
    };
  };
}
