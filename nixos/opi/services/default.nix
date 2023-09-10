{ ... }: {
  imports = [
    ./mediaserver.nix
  ];
  services = {
    haproxy-tailored = {
      enable = true;
      frontends.tls-offload-front.domain.acme.enable = false;
    };
    curltimesync = {
      enable = true;
      url = "baidu.com";
    };
  };
}
