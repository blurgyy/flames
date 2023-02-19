{ config, lib, ... }: {
  services.ssh-reverse-proxy.server = {
    services = {
      ssh-morty = {
        port = 10021;
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
      ssh-watson = {
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
    extraKnownHosts = let
      keys = import ../../_parts/defaults/public-keys.nix;
    in 
      keys.users ++ (builtins.attrValues keys.hosts);
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [ { name = "web"; condition = "if HTTP"; } ];
    backends.web = {
      mode = "http";
      requestRules = [ "replace-uri /zju(.*)$ \\1" ];
      server.address = "127.0.0.1:${toString config.services.ssh-reverse-proxy.server.services.coderp-watson.port}";
    };
  };
}