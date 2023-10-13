{ config, pkgs, ... }: let
  listenPort = 31727;
in {
  sops.secrets = {
    clash-header.restartUnits = [ "rules-server.service" ];
    clash-uuids.restartUnits = [ "rules-server.service" ];
  };

  systemd.services.rules-server = rec {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      cd /run/${serviceConfig.RuntimeDirectory}
      cp ${pkgs.cgi-rules-server}/bin/clash .
      ln -sf $CREDENTIALS_DIRECTORY/header.yaml
      ln -sf $CREDENTIALS_DIRECTORY/uuids
      ln -sf ${pkgs.clash-rules} generated.yaml
    '';
    path = [ pkgs.thttpd ];
    script = ''
      thttpd \
        -d /run/${serviceConfig.RuntimeDirectory} \
        -p ${toString listenPort} \
        -c "/clash" \
        -l /var/log/${serviceConfig.LogsDirectory}/rules-server.log \
        -D
    '';
    serviceConfig = {
      DynamicUser = true;
      LoadCredential = [
        "header.yaml:${config.sops.secrets.clash-header.path}"
        "uuids:${config.sops.secrets.clash-uuids.path}"
      ];
      RuntimeDirectory = "rules-server";
      RuntimeDirectoryMode = "0700";
      LogsDirectory = "rules-server";
      LogsDirectoryMode = "0700";
      Restart = "always";
      RestartSec = 5;
    };
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [
      { name = "rules-server"; condition = "if { path_beg /clash/ }"; }
    ];
    backends.rules-server = {
      mode = "http";
      server.address = "127.0.0.1:${toString listenPort}";
    };
  };
}
