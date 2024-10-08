{ config, pkgs, ... }:

let
  radicleHttpdDomain = "radicle.${config.networking.domain}";
  radicleExplorerDomain = "git.${config.networking.domain}";

  radicleHttpPort = 18737;
  radicleExplorerPort = 13373;
in

{
  services.radicle = {
    enable = true;
    httpd = {
      enable = true;
      listenAddress = "127.0.0.1";
      listenPort = radicleHttpPort;
    };
    node = {
      listenAddress = "0.0.0.0";  # use IPv4
      listenPort = 8776;
    };
    privateKeyFile = config.sops.secrets.hostKey.path;
    publicKey = (import ../../_parts/defaults/public-keys.nix).hosts.${config.networking.hostName};
    settings = {
      external_addresses = [
        "${radicleHttpdDomain}:${toString config.services.radicle.node.listenPort}"
      ];
      node = {
        alias = "highsunz@${config.networking.hostName}";
        seedingPolicy = {
          default = "allow";  # or "block".  Only "allow" seems to allow `rad sync`?
        };
      };
      web = {
        pinned = {
          repositories = [
            "rad:z3L8Nyj3A2eAyvqbLsw1S27T88wai"  # flames
            "rad:z2vxLfsGxa93qn8ycwcX3hcqs3Tj1"  # zstdp
          ];
        };
      };
    };
  };

  systemd.services.radicle-explorer = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.dufs}/bin/dufs ${pkgs.radicle-explorer-highsunz} \
        -p ${toString radicleExplorerPort} \
        --render-index \
        --render-spa
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
    };
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [
        { name = "is_radicle_httpd"; body = "hdr(host) -i ${radicleHttpdDomain}"; }
        { name = "is_radicle_explorer"; body = "hdr(host) -i ${radicleExplorerDomain}"; }
      ];
      domain.extraNames = [ radicleHttpdDomain radicleExplorerDomain ];
      backends = [
        { name = "radicle-httpd"; condition = "if is_radicle_httpd"; }
        { name = "radicle-explorer"; condition = "if is_radicle_explorer"; }
      ];
    };
    backends = {
      radicle-httpd = {
        mode = "http";
        server.address = "${config.services.radicle.httpd.listenAddress}:${toString config.services.radicle.httpd.listenPort}";
      };
      radicle-explorer = {
        mode = "http";
        server.address = "127.0.0.1:${toString radicleExplorerPort}";
      };
    };
  };

  networking.firewall-tailored.acceptedPorts = [
    {
      port = config.services.radicle.node.listenPort;
      comment = "Radicle node listen port";
      protocols = [ "tcp" ];
    }
  ];
}
