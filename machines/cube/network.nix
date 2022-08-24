{ config, ... }: {
  networking.nftables.ruleset = builtins.readFile ../_parts/raw/nftables-default.conf;
  services.haproxy-tailored = {
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
  };
}
