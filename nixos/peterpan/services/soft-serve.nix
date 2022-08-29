{ config, ... }: {
  sops.secrets."soft-serve/hostkey" = {
    owner = config.users.users.softserve.name;
    group = config.users.groups.softserve.name;
  };
  services.soft-serve = {
    enable = true;
    bind.addr = "0.0.0.0";
    bind.port = 77;
    display.name = "Git Server TUI (hosted with soft-serve on ${config.networking.hostName})";
    display.host = "${config.networking.fqdn}";
    keyFile = config.sops.secrets."soft-serve/hostkey".path;
    #repoDirectory
    anonAccess = "no-access";
    allowKeyless = true;
    users.gy = {
      isAdmin = true;
      publicKeys = config.users.users.gy.openssh.authorizedKeys.keys;
      collabRepos = [];
    };
  };
  networking.firewall-tailored.acceptedPorts = [{
    port = config.services.soft-serve.bind.port;
    protocols = [ "tcp" ];
    comment = "Allow traffic on soft-serve's hosting port";
  }];
}
