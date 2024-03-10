{ config, lib, pkgs, ... }:

let
  dataDir = "webdav";  # /var/lib/webdav
  webdavDomain = "webdav.${config.networking.domain}";
  listenPort = 28067;
  format = pkgs.formats.toml {};
in

{
  sops.secrets.webdav = {
    owner = config.users.users.webdav.name;
    group = config.users.groups.webdav.name;
  };
  services.webdav-server-rs = {
    enable = true;
    settings = {
      server.listen = [ "127.0.0.1:${toString listenPort}" ];
      accounts = {
        auth-type = "htpasswd.webdav";
        acct-type = "unix";
      };
      # actual passwords in ../secrets.yaml
      htpasswd.webdav.htpasswd = pkgs.writeText "webdav-htpasswd" "gy:$2y$05$nxPpwcYntdzL9kkz.TOK4eJRaxrkGEYYPq2EmpNPrTBRweFauN05S\n";
      location = [{
        route = [ "/*path" ];
        directory = "/var/lib/${dataDir}";
        handler = "filesystem";
        methods = [ "webdav-rw" "http-ro" ];
        auth = "true";
      }];
    };
    debug = true;
  };
  systemd.services.webdav-server-rs.serviceConfig = {
    User = config.users.users.webdav.name;
    Group = config.users.groups.webdav.name;
    StateDirectory = dataDir;
    StateDirectoryMode = "0700";
    ExecStart = let
      cfg = config.services.webdav-server-rs;
    in
      lib.mkForce "${pkgs.webdav-server-rs}/bin/webdav-server ${lib.optionalString cfg.debug "--debug"} -c ${format.generate "webdav-server.toml" cfg.settings}";
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [ { name = "is_webdav"; body = "hdr(host) -i ${webdavDomain}"; } ];
      domain.extraNames = [ webdavDomain ];
      backends = [ { name = "webdav"; condition = "if is_webdav"; } ];
    };
    backends.webdav = {
      mode = "http";
      server.address = "127.0.0.1:${toString listenPort}";
    };
  };
}
