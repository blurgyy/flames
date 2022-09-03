{
  enable = true;
  controlMaster = "auto";
  controlPath = "~/.ssh/master-%r@%n:%p";
  compression = true;
  serverAliveInterval = 60;
  serverAliveCountMax = 3;
  matchBlocks = let 
    peterpan = "81.69.28.75";
    cindy = "130.61.57.3";
    cube = "45.78.17.205";
    hooper = "64.64.244.30";
    relay = peterpan;
  in {
    pp = { hostname = peterpan; };
    hooper = { hostname = hooper; };
    cindy = { hostname = cindy; };
    cube = { hostname = cube; };

    gpp = { hostname = peterpan; port = 77; };
    ghooper = { hostname = hooper; user = "git"; };

    m = { hostname = relay; port = 10021; };
    w = {
      hostname = relay;
      port = 10020;
      localForwards = [
        { host.port = 3000; bind.port = 43000; host.address = "localhost"; }
        { host.port = 6006; bind.port = 46006; host.address = "localhost"; }
        { host.port = 9091; bind.port = 49091; host.address = "localhost"; }
      ];
    };
    pi = { hostname = relay; user = "root"; port = 10013; };

    hy = { hostname = "10.76.2.98"; user = "haoyu"; };
    glab = { hostname = "10.76.2.83"; user = "git"; port = 9962; };
    "2x1080ti" = {
      hostname = relay;
      port = 10023;
    };
    shared = {
      hostname = relay;
      port = 10025;
    };

    github = { hostname = "github.com"; user = "git"; };
    aur = { hostname = "aur.archlinux.org"; user = "aur"; };
  };
}
