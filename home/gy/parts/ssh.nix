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
    peterpan = "81.69.28.75";
    relay = peterpan;

    morty-relay = { hostname = relay; port = 10021; };
    winston-relay = {
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
    mono-relay = { hostname = relay; port = 20497; };

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
    "hexa"
    "hooper"
    "meda"
    "mono"
    "morty"
    "opi"
    "penta"
    "peterpan"
    "quad"
    "rpi"
    "rubik"
    "winston"
  ])) // rec {
    inherit morty-relay winston-relay;
    inherit rpi-relay copi-relay opi-relay;
    inherit "2x1080ti-relay" shared-relay mono-relay;

    # # Subnet routes via winston. use with `tailscale up --advertise-routes=10.76.0.0/21` on winston
    # # and `tailscale up --accept-routes` on client machines.
    # shared.hostname = "10.76.2.83";

    # Forwarded via winston
    shared = {
      hostname = "winston";
      port = 22548;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };
    "2x1080ti" = {
      hostname = "winston";
      port = 13815;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };

    morty-copi = {
      hostname = "morty";
      proxyJump = "copi";
    };
    rpi-copi = {
      hostname = "rpi";
      proxyJump = "copi";
    };
    winston-copi = {
      hostname = "10.76.2.80";
      proxyJump = "copi";
    };
    shared-copi = {
      hostname = "10.76.2.83";
      proxyJump = "copi";
      port = 22548;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };
    "2x1080ti-copi" = {
      hostname = "winston";
      proxyJump = "copi";
      port = 13815;
      extraOptions.
        RemoteForward = "/run/user/1001/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent /run/user/1000/gnupg/d.ednwhmbipggmtegq5y9aobig/S.gpg-agent";
    };
    mono-raw = {
      hostname = "192.168.1.102";
      proxyJump = "2x1080ti";
    };
    mono-winston = {
      hostname = "winston";
      port = 17266;
    };
    mono-copi = mono-winston // { proxyJump = "copi"; };

    gpp = { hostname = "peterpan"; port = 77; };
    ghooper = { hostname = "hooper"; user = "git"; };

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

    ubuntu-jammy = {
      hostname = "winston";
      port = 1722;
    };
    ubuntu-jammy-copi = {
      hostname = "winston";
      proxyJump = "copi";
      port = 1722;
    };
    ubuntu-jammy-relay = {
      hostname = relay;
      port = 16251;
    };
  };
}
