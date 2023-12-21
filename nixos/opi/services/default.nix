{ ... }: {
  imports = [
    ./mediaserver.nix
    ./rp.nix
  ];
  services = {
    haproxy-tailored = {
      enable = true;
      frontends.tls-offload-front.domain.acme.enable = false;
    };
    curltimesync = {
      enable = true;
      url = "114.222.113.139";  # im.qq.com
    };
  };
}
