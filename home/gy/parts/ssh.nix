{ lib, name, mergeAttrsList }: {
  enable = true;
  controlMaster = "auto";
  controlPath = "~/.ssh/master-%r@%n:%p";
  compression = true;
  serverAliveInterval = 60;
  serverAliveCountMax = 3;
  includes = [
    "config.d/*"
  ];
  matchBlocks = let 
    peterpan = "81.69.28.75";
    relay = peterpan;

    morty-relay = { hostname = relay; port = 10021; };
    watson-relay = {
      hostname = relay;
      port = 10020;
      localForwards = [
        { host.port = 3000; bind.port = 43000; host.address = "localhost"; }
        { host.port = 6006; bind.port = 46006; host.address = "localhost"; }
        { host.port = 9091; bind.port = 49091; host.address = "localhost"; }
      ];
    };
    rpi-relay = { hostname = relay; port = 10013; };
    "2x1080ti-relay" = { hostname = relay; port = 10023; };
    shared-relay = { hostname = relay; port = 10025; };

    applyHostname = hostnames: map (hostname: { ${hostname} = { inherit hostname; }; }) hostnames;
  in (mergeAttrsList (applyHostname [
    "cindy"
    "cube"
    "hooper"
    "morty"
    "peterpan"
    "quad"
    "rpi"
    "rubik"
    "trigo"
    "watson"
  ])) // {
    inherit morty-relay watson-relay rpi-relay "2x1080ti-relay" shared-relay;

    # Subnet routes via watson. use with `tailscale up --advertise-routes=192.168.1.0/24` on watson
    # and `tailscale up --accept-routes` on client machines.
    "2x1080ti".hostname = "192.168.1.22";
    shared.hostname = "192.168.1.23";

    glab = { hostname = "10.76.2.83"; user = "git"; port = 9962; };
    gpp = { hostname = "peterpan"; port = 77; };
    ghooper = { hostname = "hooper"; user = "git"; };

    hy = { hostname = "10.76.2.98"; user = "haoyu"; };

    github = { hostname = "github.com"; user = "git"; };
    aur = { hostname = "aur.archlinux.org"; user = "aur"; };
  };
}
