{ config, lib, ... }: {
  services.ssh-reverse-proxy.server = {
    services = {
      ssh-morty = 10021;
      ssh-opi = 6229;
      ssh-rpi = 10013;
      ssh-2x1080ti = 10023;
      ssh-shared = 10025;

      acremote-rpi = 21607;
      coderp-watson = 1111;
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
      server.address = "127.0.0.1:${toString config.services.ssh-reverse-proxy.server.services.coderp-watson}";
    };
  };
}
