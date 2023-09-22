{ config, pkgs, ... }: {
  services = {
    aliyundrive-mediaserver = {
      enable = true;
      package = {
        backend = pkgs.aliyundrive-mediaserver-backend;
        frontend = pkgs.aliyundrive-mediaserver-frontend;
        rclone = pkgs.rclone;
        inherit (pkgs) aliyundrive-webdav;
      };
      port = {
        aliyundrive-mediaserver = 1313;
        file-explorer = 8518;
      };
      serverName = config.networking.hostName;
    };
    haproxy-tailored = {
      frontends.tls-offload-front.backends = [
        { name = "file-explorer"; condition = "if { path_beg /explore/ } || { path_beg /__dufs }"; }
        # { name = "aliyundrive-mediaserver"; isDefault = true; }
      ];
      backends = let
        cfg = config.services.aliyundrive-mediaserver;
      in {
        file-explorer = {
          mode = "http";
          options = [ "forwardfor" ];
          requestRules = [ "replace-uri /explore(.*)$ \\1" ];
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
