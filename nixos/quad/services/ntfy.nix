{ ... }: let
  ntfyDomain = "ntfy.blurgy.xyz";
  ntfyPort = 2769;
in {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${ntfyDomain}";
      behind-proxy = true;
      listen-http = "127.0.0.1:${toString ntfyPort}";
      upstream-base-url = "https://ntfy.sh";
    };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [{
        name = "is_ntfy"; body = "hdr(host) -i ${ntfyDomain}";
      }];
      domain.extraNames = [ ntfyDomain ];
      backends = [{
        name = "ntfy"; condition = "if is_ntfy"; 
      }];
    };
    backends.ntfy = {
      mode = "http";
      server.address = "127.0.0.1:${toString ntfyPort}";
    };
  };
}
