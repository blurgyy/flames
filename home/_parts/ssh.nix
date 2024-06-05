{ proxy, hostName, lib, pkgs, mergeAttrsList }: {
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
    relay = "peterpan";

    addGpgRemoteForward = uid: config: config // {
      remoteForwards = config.remoteForwards or [] ++ [{
        host.address = "/run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
        bind.address = "/run/user/${toString uid}/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
      }];
    } // config;

    morty-relay = addGpgRemoteForward 1000 { hostname = relay; port = 10021; };
    winston-relay = addGpgRemoteForward 1000 {
      hostname = relay;
      port = 10020;
      localForwards = [
        { host.port = 3000; bind.port = 43000; host.address = "localhost"; }
        { host.port = 6006; bind.port = 46006; host.address = "localhost"; }
        { host.port = 9091; bind.port = 49091; host.address = "localhost"; }
      ];
    };
    rpi-relay = addGpgRemoteForward 1000 { hostname = relay; port = 10013; };
    copi-relay = addGpgRemoteForward 1000 { hostname = relay; port = 2856; };
    opi-relay = addGpgRemoteForward 1000 { hostname = relay; port = 6229; };
    "2x1080ti-relay" = addGpgRemoteForward 1001 { hostname = relay; port = 10023; };
    shared-relay = addGpgRemoteForward 1001 { hostname = relay; port = 10025; };
    mono-relay = addGpgRemoteForward 1000 { hostname = relay; port = 20497; };

    apply = hostnames: map (hostname: {
        ${hostname} = addGpgRemoteForward 1000 { inherit hostname; };
      }) hostnames;
  in (mergeAttrsList (apply [
    "cindy"
    "copi"
    "hexa"
    "meda"
    "mono"
    "morty"
    "octa"
    "opi"
    "peterpan"
    "quad"
    "rpi"
    "rubik"
    "velo"
    "winston"
  ])) // rec {
    inherit morty-relay winston-relay;
    inherit rpi-relay copi-relay opi-relay;
    inherit "2x1080ti-relay" shared-relay mono-relay;

    octa-nat = addGpgRemoteForward 1000 {
      hostname = "203.3.115.226";
      port = 10005;
    };

    # # Subnet routes via winston. use with `tailscale up --advertise-routes=10.76.0.0/21` on winston
    # # and `tailscale up --accept-routes` on client machines.
    # shared.hostname = "10.76.2.83";

    # Forwarded via winston
    shared = addGpgRemoteForward 1001 {
      hostname = "winston";
      port = 22548;
    };
    "2x1080ti" = addGpgRemoteForward 1001 {
      hostname = "winston";
      port = 13815;
    };

    morty-copi = addGpgRemoteForward 1000 {
      hostname = "morty";
      proxyJump = "copi";
    };
    rpi-copi = addGpgRemoteForward 1000 {
      hostname = "rpi";
      proxyJump = "copi";
    };
    winston-copi = addGpgRemoteForward 1000 {
      hostname = "10.76.2.80";
      proxyJump = "copi";
    };
    winston-copi-relay = addGpgRemoteForward 1000 {
      hostname = "10.76.2.80";
      proxyJump = "copi-relay";
    };
    winston-rpi-relay = addGpgRemoteForward 1000 {
      hostname = "10.76.2.80";
      proxyJump = "rpi-relay";
    };
    shared-copi = addGpgRemoteForward 1001 {
      hostname = "10.76.2.83";
      proxyJump = "copi";
      port = 22548;
    };
    "2x1080ti-copi" = addGpgRemoteForward 1001 {
      hostname = "winston";
      proxyJump = "copi";
      port = 13815;
    };
    mono-raw = addGpgRemoteForward 1000 {
      hostname = "192.168.1.102";
      proxyJump = "2x1080ti";
    };
    mono-winston = addGpgRemoteForward 1000 {
      hostname = "winston";
      port = 17266;
    };
    mono-copi = addGpgRemoteForward 1000 (mono-winston // { proxyJump = "copi"; });

    gpp = { hostname = "peterpan"; port = 77; };

    ubuntu-jammy = addGpgRemoteForward 1001 {
      hostname = "winston";
      port = 1722;
    };
    ubuntu-jammy-copi = addGpgRemoteForward 1001 {
      hostname = "winston";
      proxyJump = "copi";
      port = 1722;
    };
    ubuntu-jammy-relay = addGpgRemoteForward 1001 {
      hostname = relay;
      port = 16251;
    };

    hy = { hostname = "10.76.2.98"; user = "haoyu"; };

    "github github.com" = {
      hostname = "github.com";
      user = "git";
    };
    "gitlab gitlab.com" = {
      hostname = "gitlab.com";
      user = "git";
    };
    "github github.com gitlab gitlab.com" = if proxy == null
      then {}
      else if builtins.hasAttr "http" proxy
      then { proxyCommand = "${pkgs.socat}/bin/socat - proxy:${(proxy.envVarsFor hostName).http._proxy_addr}:%h:%p,proxyport=${(proxy.envVarsFor hostName).http._proxy_port}"; }
      else if builtins.hasAttr "socks" proxy
      then { proxyCommand = "${pkgs.socat}/bin/socat - socks:${(proxy.envVarsFor hostName).socks._proxy_addr}:%h:%p,socksport=${(proxy.envVarsFor hostName).socks._proxy_port}"; }
      else {};
    aur = { hostname = "aur.archlinux.org"; user = "aur"; };
  };
}
