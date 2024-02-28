{ config, ... }: let
  wakapiDomain = "codingstats.${config.networking.domain}";
in {
  sops.secrets = {
    "wakapi/salt" = {};
    "wakapi/smtp/username" = {};
    "wakapi/smtp/password" = {};
  };
  services = {
    wakapi = {
      enable = true;
      server = {
        addr = "127.0.0.1";
        port = 31243;
        publicUrl = "https://${wakapiDomain}";
      };
      security = {
        passwordSalt = config.sops.placeholder."wakapi/salt";
        allowSignup = true;
        exposeMetrics = false;
      };
      smtp = {
        enable = true;
        sender = "Wakapi <wakapi@${config.networking.domain}>";
        host = config.networking.domain;
        port = 587;
        username = config.sops.placeholder."wakapi/smtp/username";
        password = config.sops.placeholder."wakapi/smtp/password";
        tls = false;
      };
    };
    haproxy-tailored = {
      frontends.tls-offload-front = {
        acls = [ { name = "is_wakapi"; body = "hdr(host) -i ${wakapiDomain}"; } ];
        domain.extraNames = [ wakapiDomain ];
        backends = [ { name = "wakapi"; condition = "if is_wakapi"; } ];
      };
      backends.wakapi = {
        mode = "http";
        server.address = "127.0.0.1:${toString config.services.wakapi.server.port}";
      };
    };
  };
}
