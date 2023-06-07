{ config, ... }: {
  sops.secrets = let
    ownerAndGroupCfg = {
      owner = config.users.users.softserve.name;
      group = config.users.groups.softserve.name;
    };
  in {
    "soft-serve/hostKey" = ownerAndGroupCfg;
    "soft-serve/clientKey" = ownerAndGroupCfg;
  };
  services.soft-serve = {
    enable = true;
    ## just use default bind addrs/ports
    # bind = {
    display.name = "Git Server TUI (hosted with soft-serve on ${config.networking.hostName})";
    display.host = "${config.networking.fqdn}";
    hostKey = config.sops.secrets."soft-serve/hostKey".path;
    clientKey = config.sops.secrets."soft-serve/clientKey".path;
    adminPublicKeys = config.users.users.gy.openssh.authorizedKeys.keys;
  };
  networking.firewall-tailored.acceptedPorts = [{
    port = config.services.soft-serve.bind.sshPort;
    protocols = [ "tcp" ];
    comment = "Allow traffic on soft-serve's SSH server";
  } {
    port = config.services.soft-serve.bind.httpPort;
    protocols = [ "tcp" ];
    comment = "Allow traffic on soft-serve's HTTP server";
  }];
}
