{ config, lib
, cfg
, tunCidr
}:

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
        args = (intersectAttrs (functionArgs f) { inherit config lib; }) // overrides;
      in f args;

  applyTagWithOverrides = overrides: path: {
    tag = with lib; strings.removeSuffix ".nix" (lists.last (splitString "/" path));
  } // (call path overrides);

  filterMapDir = f: siftFn: path: with builtins;
    map f
      (map
        (subPath: "${path}/${subPath}")
        (filter
          siftFn
          (attrNames (readDir path))));

  mapDir = f: path: filterMapDir f (_: true) path;
in

{
  log = {
    level = "info";
    timestamp = false;  # journald already handles that
  };

  dns = import ./dns { inherit mapDir applyTagWithOverrides; };

  outbounds = import ./outbounds { inherit mapDir applyTagWithOverrides; };

  route = import ./route { inherit mapDir call; };

  inbounds = [{
    type = "mixed";
    tag = "mixed-in";
    listen = "0.0.0.0";
    listen_port = 9988;
    sniff = true;
    sniff_override_destination = true;  # Override the connection destination address with the sniffed domain
  } {
    type = "tun";
    tag = "tun-in";
    interface_name = cfg.tunInterface;
    inet4_address = tunCidr;
    auto_route = true;
    # enabling `strict_route` makes the device unreachable via ssh (ping is fine) from physical
    # interfaces (but still reachable via ssh through tailscale's tun)
    strict_route = false;
    # system/gvisor/mixed, only gvisor seems to be able to capture all traffic to tun
    stack = "gvisor";
    mtu = 1500;
    sniff = true;
    sniff_timeout = "300ms";
    sniff_override_destination = true;  # Override the connection destination address with the sniffed domain
    udp_timeout = 300;  # in seconds, a value of 300 gives 5min
  }];

}
