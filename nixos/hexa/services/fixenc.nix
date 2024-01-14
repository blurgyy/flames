{ config, pkgs, ... }:

let
  fixencDomain = "fixenc.${config.networking.domain}";
in

{
  systemd.services.fixenc = {
    script = "${pkgs.fixenc}";
    wantedBy = [ "multi-user.target" ];
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      domain.extraNames = [ fixencDomain ];
      acls = [ { name = "is_fixenc"; body = "hdr(host) -i ${fixencDomain}"; } ];
      backends = [ { name = "fixenc"; isDefault = true; } ];
    };
    backends.fixenc = {
      mode = "http";
      server.address = "127.0.0.1:4857";  # TODO: do not hard code this port in the fixenc package
    };
  };
}
