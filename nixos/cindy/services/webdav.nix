{ config, pkgs, ... }: let
  dataDir = "webdav";  # /var/lib/webdav
  webdavDomain = "webdav.${config.networking.domain}";
in {
  sops.secrets.webdav = {
    owner = config.users.users.webdav.name;
    group = config.users.groups.webdav.name;
  };
  services.webdav = {
    enable = true;
    settings = {
      address = "127.0.0.1";
      port = 28067;
      scope = "/var/lib/${dataDir}";
      modify = true;
      auth = true;
      users = [{
        username = "{env}WEBDAV_USERNAME";
        password = "{env}WEBDAV_PASSWORD";
        scope = "/var/lib/${dataDir}/gy";
      }];
    };
    environmentFile = config.sops.secrets.webdav.path;
  };
  systemd.services.webdav.serviceConfig = {
    StateDirectory = dataDir;
    StateDirectoryMode = "0700";
    ProtectSystem = "strict";
    ExecStartPre = map (userInfo: "${pkgs.coreutils}/bin/mkdir -p ${userInfo.scope}")
      (builtins.filter (userInfo: builtins.hasAttr "scope" userInfo) config.services.webdav.settings.users);
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [ { name = "is_webdav"; body = "hdr(host) -i ${webdavDomain}"; } ];
      domain.extraNames = [ webdavDomain ];
    };
    backends.webdav = {
      mode = "http";
      server.address = "127.0.0.1:${toString config.services.webdav.settings.port}";
    };
  };
}
