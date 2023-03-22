{ config, lib, ... }: let
  cfg = config.services.ntfy-tailored;
in with lib; {
  options.services.ntfy-tailored = {
    enable = mkEnableOption "Whether to enable ntfy-sh service";
    domain = mkOption { type = types.str; };
    port = mkOption {
      type = with types; oneOf [ str int ];
      default = 2769;
    };
  };
  config = mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}";
        behind-proxy = true;
        listen-http = "127.0.0.1:${toString cfg.port}";
        upstream-base-url = "https://ntfy.sh";
      };
    };

    services.haproxy-tailored = {
      frontends.tls-offload-front = {
        acls = [{
          name = "is_ntfy"; body = "hdr(host) -i ${cfg.domain}";
        }];
        domain.extraNames = [ cfg.domain ];
        backends = [{
          name = "ntfy"; condition = "if is_ntfy";
        }];
      };
      backends.ntfy = {
        mode = "http";
        server.address = "127.0.0.1:${toString cfg.port}";
      };
    };
  };
}
