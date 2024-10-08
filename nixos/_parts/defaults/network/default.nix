{ config, pkgs, ... }: {
  imports = [
    ./tailscale.nix
  ];

  services.warp-proxy.enable = let
    isPlatformSupported = builtins.elem
      pkgs.stdenv.hostPlatform.system
      config.services.warp-proxy.package.meta.platforms;
    isOverseaBox = config.time.timeZone != "Asia/Shanghai";
  in isPlatformSupported && isOverseaBox;

  networking.firewall-tailored = {
    enable = true;
    acceptedPorts = [ "ssh" "http" "https" ] ++ [{
      port = config.services.tailscale.port;
      protocols = [ "udp" ];
      comment = "tailscale tunnel listening port";
    } {
      port = "1714-1764";
      protocols = [ "tcp" "udp" ];
      comment = "KDEConnect communication ports";
    }];
    rejectedAddrGroups = [{
      addrs = (import ./banned-ips/ssh-scanners.nix);
      countPackets = true;
      comment = "reject known ssh scanners";
    } {
      addrs = (import ./banned-ips/smtp-scanners.nix);
      countPackets = true;
      comment = "reject known smtp scanners";
    } {
      addrs = (import ./banned-ips/http-proxy-scanners.nix);
      countPackets = true;
      comment = "reject known http-proxy scanners";
    }];
    acceptedAddrGroups = [{
      addrs = [ "$private_range" ];
      countPackets = true;
      comment = "allow machines from private network to access arbitrary port";
    }];
    referredServices = [];
  };
}
