{ config }: {
  client.remote_addr = config.sops.placeholder."rathole/remote_addr";
  client.services."ssh-${config.networking.hostName}" = {
    token = config.sops.placeholder."rathole/ssh/token";
    local_addr = "127.1:22";
  };
}
