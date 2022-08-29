{ config, ... }: {
  sops.secrets = {
    "rathole/remote_addr" = {};
    "rathole/ssh/token" = {};
    "rathole/acremote/token" = {};
  };
  services.rathole = {
    enable = true;
    client = {
      remoteAddr = config.sops.placeholder."rathole/remote_addr";
      services = [
        {
          name = "ssh-${config.networking.hostName}";
          token = config.sops.placeholder."rathole/ssh/token";
          localAddr = "127.1:22";
        }
        {
          name = "acremote-${config.networking.hostName}";
          token = config.sops.placeholder."rathole/acremote/token";
          localAddr = "127.1:12682";
        }
      ];
    };
  };
}
