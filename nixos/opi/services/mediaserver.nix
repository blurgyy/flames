{ config, lib, pkgs, ... }: {
  services = {
    aliyundrive-mediaserver = {
      enable = true;
      package = {
        backend = pkgs.aliyundrive-mediaserver-backend;
        frontend = pkgs.aliyundrive-mediaserver-frontend;
        aliyundrive-fuse = pkgs.aliyundrive-fuse-mobile;
        inherit (pkgs) aliyundrive-webdav;
      };
      port = {
        aliyundrive-mediaserver = 1313;
        file-explorer = 8518;
        gerbera = 50000;  # must be larer than 49152?  See man:gerbera(1)
      };
    };
    haproxy-tailored = {
      frontends.http-in = {
        requestRules = lib.mkForce [];
        backends = [
          { name = "file-explorer"; condition = "if { path_beg /explore/ } || { path_beg /__dufs }"; }
          { name = "gerbera"; condition = "if { path_beg /gerbera/ }"; }
          { name = "aliyundrive-mediaserver"; isDefault = true; }
        ];
      };
      backends = let
        cfg = config.services.aliyundrive-mediaserver;
      in {
        file-explorer = {
          mode = "http";
          options = [ "forwardfor" ];
          requestRules = [ "replace-uri /explore(.*)$ \\1" ];
          server.address = "127.0.0.1:${toString cfg.port.file-explorer}";
        };
        gerbera = {
          mode = "http";
          options = [ "forwardfor" ];
          requestRules = [ "replace-uri /gerbera(.*)$ \\1" ];
          server.address = "127.0.0.1:${toString cfg.port.gerbera}";
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
