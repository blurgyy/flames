{ config, ... }:

let
  proxy-zju-port = 1096;
in

{
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
      ssh-winston-jammy = {
        port = 16251;
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
      ssh-mono = {
        port = 20497;
        expose = true;
      };

      acremote-rpi = {
        port = 21607;
        expose = true;
      };
      coderp-watson.port = 1111;

      rdp-octa = {
        port = 3389;
        expose = true;
      };

      proxy-zju-via-copi.port = 2096;
      proxy-zju-via-rpi.port = 3096;
    };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [
      { name = "web"; condition = "if { path_beg /zju/ }"; }
      { name = "proxy-zju"; condition = "if !HTTP"; }
    ];
    frontends = {
      zju-proxy = {
        mode = "tcp";
        binds = [ "*:${toString proxy-zju-port}" ];
        backends = [ { name = "zju-proxy-balancer"; isDefault = true; } ];
      };
    };
    backends = let
      mkServer = port: { address = "127.0.0.1:${toString port}"; };
    in {
      zju-proxy-balancer = {
        mode = "tcp";
        balancer = "roundrobin";
        servers = map mkServer [ 2096 3096 4096 5096 6096 7096 8096 9096 ];
      };
      web = {
        mode = "http";
        requestRules = [ "replace-uri /zju(.*)$ \\1" ];
        server.address = "127.0.0.1:${toString config.services.ssh-reverse-proxy.server.services.coderp-watson.port}";
      };
      proxy-zju = {
        mode = "tcp";
        server.address = "127.0.0.1:${toString proxy-zju-port}";
      };
    };
  };
}
