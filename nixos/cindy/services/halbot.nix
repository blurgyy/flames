{ config, pkgs, ... }: {
  sops.secrets."halbot.json" = {};

  systemd.services.halbot = {
    documentation = [ "https://github.com/Leask/halbot" ];
    path = [ pkgs.halbot ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
      PrivateTmp = true;
      LoadCredential = ".halbot.json:${config.sops.secrets."halbot.json".path}";
    };
    script = ''
      export HOME="$CREDENTIALS_DIRECTORY"
      halbot
    '';
  };
}
