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
      url = "109.244.194.121";  # tencent.com
    };
  };
}
