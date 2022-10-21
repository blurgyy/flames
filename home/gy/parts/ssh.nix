{ name }: {
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
    cindy = "130.61.57.3";
    cube = "45.78.17.205";
    hooper = "64.64.244.30";
    quad = "45.139.193.21";
    rubik = "193.32.151.152";
    trigo = "154.9.139.26";
    tetra = "154.12.36.120";
    relay = peterpan;

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
    pi = { hostname = relay; port = 10013; };
  in {
    inherit m w pi;
    morty = m;
    watson = w;
    rpi = pi;

    pp = { hostname = peterpan; };
    hooper = { hostname = hooper; };
    cindy = { hostname = cindy; };
    cube = { hostname = cube; };
    quad = { hostname = quad; };
    rubik = { hostname = rubik; };
    trigo = { hostname = trigo; };
    tetra = { hostname = tetra; };

    gpp = { hostname = peterpan; port = 77; };
    ghooper = { hostname = hooper; user = "git"; };

    hy = { hostname = "10.76.2.98"; user = "haoyu"; };
    glab = { hostname = "10.76.2.83"; user = "git"; port = 9962; };
    "2x1080ti" = if name == "gy@watson" || name == "gy@cadliu" || name == "gy@cad-liu" then {
      hostname = "192.168.1.22";
    } else {
      hostname = relay;
      port = 10023;
    };
    shared = if name == "gy@watson" || name == "gy@cadliu" || name == "gy@cad-liu" then {
      hostname =  "192.168.1.23";
    } else {
      hostname = relay;
      port = 10025;
    };

    github = { hostname = "github.com"; user = "git"; };
    aur = { hostname = "aur.archlinux.org"; user = "aur"; };
  };
}
