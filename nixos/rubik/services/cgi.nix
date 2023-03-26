{ config, pkgs, ... }: let
  thttpdPort = 31727;
in {
  sops.secrets = {
    clash-header.restartUnits = [ "thttpd.service" ];
    clash-uuids.restartUnits = [ "thttpd.service" ];
  };

  systemd.services.thttpd = rec {
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
        -p ${toString thttpdPort} \
        -c "/clash" \
        -l /var/log/${serviceConfig.LogsDirectory}/thttpd.log \
        -D
    '';
    serviceConfig = {
      DynamicUser = true;
      LoadCredential = [
        "header.yaml:${config.sops.secrets.clash-header.path}"
        "uuids:${config.sops.secrets.clash-uuids.path}"
      ];
      RuntimeDirectory = "thttpd";
      RuntimeDirectoryMode = "0700";
      LogsDirectory = "thttpd";
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
      server.address = "127.0.0.1:${toString thttpdPort}";
    };
  };
}
