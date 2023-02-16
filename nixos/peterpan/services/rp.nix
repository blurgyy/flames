{ config, lib, ... }: {
  services.ssh-reverse-proxy.server = {
    services = {
      ssh-morty = 10021;
      ssh-rpi = 10013;

      acremote-rpi = 21607;
      coderp-watson = 1111;
    };
    extraKnownHosts = with config.services.openssh.knownHosts; [
      morty.publicKey
    ];
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
