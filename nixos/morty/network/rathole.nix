{ config, ... }: {
  sops.secrets = {
    "rathole/remote-addr" = {};
    "rathole/ssh/token" = {};
  };
  services.rathole = {
    enable = true;
    client = {
      remoteAddr = config.sops.placeholder."rathole/remote-addr";
      services."ssh-${config.networking.hostName}" = {
        token = config.sops.placeholder."rathole/ssh/token";
        localAddr = "127.1:22";
      };
    };
  };
}
