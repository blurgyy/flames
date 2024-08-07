{ config, pkgs, ... }:

let
  listenPort = 31727;
in

{
  sops.secrets = {
    clash-header.restartUnits = [ "rules-server-clash.service" ];
    proxy-client-uuids.restartUnits = [ "rules-server-clash.service" ];
  };

  systemd.services.rules-server-clash = rec {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      cd /run/${serviceConfig.RuntimeDirectory}
      cp ${pkgs.cgi-rules-server}/bin/clash .
      cat $CREDENTIALS_DIRECTORY/header.yaml ${pkgs.proxy-rules}/clash/generated.yaml >template.yaml
      ln -sf $CREDENTIALS_DIRECTORY/uuids
    '';
    script = ''
      ${pkgs.clash-rules}/bin/clash-rules \
        --template /run/${serviceConfig.RuntimeDirectory}/template.yaml \
        --users /run/${serviceConfig.RuntimeDirectory}/uuids \
        --port ${toString listenPort}
    '';
    serviceConfig = {
      DynamicUser = true;
      LoadCredential = [
        "header.yaml:${config.sops.secrets.clash-header.path}"
        "uuids:${config.sops.secrets.proxy-client-uuids.path}"
      ];
      RuntimeDirectory = "rules-server-clash";
      RuntimeDirectoryMode = "0700";
      Restart = "always";
      RestartSec = 5;
    };
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [
      { name = "rules-server-clash"; condition = "if { path_beg /clash/ }"; }
    ];
    backends.rules-server-clash = {
      mode = "http";
      requestRules = [ "replace-uri /clash(.*)$ \\1" ];
      server.address = "127.0.0.1:${toString listenPort}";
    };
  };
}
