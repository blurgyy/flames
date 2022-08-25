{ config, ... }: {
  networking.nftables = {
    enable = true;
    ruleset = builtins.readFile ../../_parts/raw/nftables-default.conf;
  };
  services = {
    haproxy-tailored = import ./haproxy.nix { inherit config; };
    rathole = {
      enable = true;
      server = {
        bindAddr = config.sops.placeholder."rathole/bind-addr";
        services = map (name: {
          inherit name;
          token = config.sops.placeholder."rathole/${name}/token";
          bindAddr = config.sops.placeholder."rathole/${name}/addr";
        }) [
          "ssh-morty"
          "ssh-rpi"
          "ssh-watson"
          "ssh-lab-2x1080ti"
          "ssh-lab-shared"
          "coderp-watson"
          "acremote-rpi"
        ];
      };
    };
    v2ray-tailored = {
      server = (import ../../_parts/v2ray.nix { inherit config; }).server // {
        reverse = {
          counterpartName = "watson";
          position = "world";
          port = 10024;
          id = config.sops.placeholder."v2ray/ports/reverse";
          proxiedDomains = [
            "cc98"
            "domain:nexushd"
            "domain:zju.edu.cn"
          ];
          proxiedIPs = [
            "10.10.0.0/22"
            "223.4.64.9/32"
            "10.76.0.0/21"
          ];
        };
      };
    };
  };
}
