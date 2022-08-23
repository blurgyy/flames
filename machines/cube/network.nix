{ config, pkgs, ... }: {
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
    ];
  };
}
