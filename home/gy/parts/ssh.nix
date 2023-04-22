{ lib, name, mergeAttrsList }: {
  enable = true;
  controlMaster = "no";
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
    copi-relay = { hostname = relay; port = 2856; };
    opi-relay = { hostname = relay; port = 6229; };
    "2x1080ti-relay" = { hostname = relay; port = 10023; };
    shared-relay = { hostname = relay; port = 10025; };

    apply = hostnames: map (hostname: {
        ${hostname} = {
          inherit hostname;
          extraOptions.
            RemoteForward = "/run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
        };
      }) hostnames;
  in (mergeAttrsList (apply [
    "cindy"
    "copi"
    "cube"
    "hooper"
    "morty"
    "opi"
    "peterpan"
    "quad"
    "rpi"
    "rubik"
    "trigo"
    "watson"
  ])) // {
    inherit morty-relay watson-relay rpi-relay copi-relay opi-relay "2x1080ti-relay" shared-relay;

    # # Subnet routes via watson. use with `tailscale up --advertise-routes=10.76.0.0/21` on watson
    # # and `tailscale up --accept-routes` on client machines.
    # shared.hostname = "10.76.2.83";

    # Forwarded via watson
    shared = {
      hostname = "watson";
      port = 22548;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };
    "2x1080ti" = {
      hostname = "watson";
      port = 13815;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };

    watson-copi = {
      hostname = "watson";
      proxyJump = "copi";
    };
    shared-copi = {
      hostname = "watson";
      proxyJump = "copi";
      port = 22548;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };
    "2x1080ti-copi" = {
      hostname = "watson";
      proxyJump = "copi";
      port = 13815;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };

    gpp = { hostname = "peterpan"; port = 77; };
    ghooper = { hostname = "hooper"; user = "git"; };

    hy = { hostname = "10.76.2.98"; user = "haoyu"; };

    github = { hostname = "github.com"; user = "git"; };
    aur = { hostname = "aur.archlinux.org"; user = "aur"; };
  };
}
