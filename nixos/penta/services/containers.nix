{ ... }:

{
  networking.firewall-tailored.acceptedPorts = [
    { port = 60003; protocols = [ "tcp" ]; }
  ];
  systemd = {
    nspawn = {
      pentp = {
        enable = true;
        execConfig.Boot = true;
        networkConfig.Private = false;
        filesConfig = {
          BindReadOnly = [
            "/etc/resolv.conf"
          ];
        };
      };
    };
    services = {
      "systemd-nspawn@pentp" = {
        overrideStrategy = "asDropin";
        wantedBy = [ "machines.target" ];
      };
    };
  };
}
