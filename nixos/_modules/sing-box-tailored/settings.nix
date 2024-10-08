{ config, lib
, cfg
, tunAddress
}:

let
  filterMapDir = f: siftFn: path: with builtins;
    map f
      (map
        (subPath: "${path}/${subPath}")
        (filter
          siftFn
          (attrNames (readDir path))));

  mapDir = f: path: filterMapDir f (_: true) path;

  # filename stem, e.g. `path/to/file.ext`'s stem is `file`
  stemOfFile = path: with lib;
    let
      basename = baseNameOf (toString path);
      suffixWithoutDot = last (splitString "." basename);
    in
      builtins.unsafeDiscardStringContext (removeSuffix ".${suffixWithoutDot}" basename);
in

let
  call = path: overrides:
    with builtins;

    let
      f = import path;
    in

    if (typeOf f) != "lambda" then
      f

    else
      let
        args = (
          intersectAttrs
            (functionArgs f)
            {
              inherit config lib;
              inherit mapDir applyTagWithOverrides applyTag call;
              inherit (cfg) secretPath;
            }
          ) // overrides;
      in f args;

  applyTagWithOverrides = overrides: path: {
    tag = stemOfFile path;
  } // (call path overrides);

  applyTag = path: applyTagWithOverrides {} path;
in

{
  log = {
    level = "info";
    timestamp = false;  # journald already handles that
  };

  dns = call ./dns {};

  outbounds = call ./outbounds {};

  route = call ./route {};

  inbounds = [{
    type = "http";
    tag = "http-in";
    listen = "0.0.0.0";
    listen_port = 9990;
    sniff = true;
    sniff_override_destination = true;  # Override the connection destination address with the sniffed domain
  } {
    type = "socks";
    tag = "socks-in";
    listen = "0.0.0.0";
    listen_port = 9999;
    sniff = true;
    sniff_override_destination = true;  # Override the connection destination address with the sniffed domain
  } {
    type = "tun";
    tag = "tun-in";
    interface_name = cfg.tunInterface;
    inet4_address = tunAddress;
    auto_route = true;
    exclude_interface = if config.networking.nat.enable
      then config.networking.nat.internalInterfaces
      else [];
    # inet4_route_exclude_address = [
    #   "0.0.0.0/8"
    # ];
    # inet6_route_exclude_address = [
    #   "::/128"
    # ];
    # enabling `strict_route` makes the device unreachable via ssh (ping is fine) from physical
    # interfaces (but still reachable via ssh through tailscale's tun)
    strict_route = false;
    # system/gvisor/mixed
    stack = "system";
    mtu = 1500;
    sniff = true;
    sniff_timeout = "300ms";
    sniff_override_destination = true;  # Override the connection destination address with the sniffed domain
    udp_timeout = 300;  # in seconds, a value of 300 gives 5min
  }];

}
