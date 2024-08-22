{ config, pkgs, inputs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in

{
  services = {
    aliyundrive-mediaserver = {
      enable = true;
      package = {
        inherit (pkgs) rclone;
        inherit (inputs.adrivems.packages.${system}) backend frontend aliyundrive-webdav;
      };
      port = {
        aliyundrive-mediaserver = 1313;
        file-explorer = 8518;
      };
      explorerPathPrefix = "explore";
      serverName = config.networking.hostName;
    };
    haproxy-tailored = {
      frontends.tls-offload-front.backends = [
        {
          name = "file-explorer";
          condition = "if { path_beg /${config.services.aliyundrive-mediaserver.explorerPathPrefix} }";
        }
        # { name = "aliyundrive-mediaserver"; isDefault = true; }
      ];
      backends = let
        cfg = config.services.aliyundrive-mediaserver;
      in {
        file-explorer = {
          mode = "http";
          options = [ "forwardfor" ];
          server.address = "127.0.0.1:${toString cfg.port.file-explorer}";
        };
        aliyundrive-mediaserver = {
          mode = "http";
          options = [ "forwardfor" ];
          server.address = "127.0.0.1:${toString cfg.port.aliyundrive-mediaserver}";
        };
      };
    };
  };
}
