{ pkgs, config, ... }: {
  sops.secrets.wireless-environment-file = {};
  networking.wireless = {
    enable = true;
    environmentFile = config.sops.secrets.wireless-environment-file.path;
    networks = {
      "@wlan_0@" = { psk = "@wlan_0_psk@"; priority = 100; };
      "@wlan_1@" = { psk = "@wlan_1_psk@"; priority = 100; };
      "@wlan_2@" = { psk = "@wlan_2_psk@"; priority = 75; };
      "@wlan_3@" = { psk = "@wlan_3_psk@"; priority = 50; };
      "ZJUWLAN".authProtocols = [ "NONE" ];
      "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
    };
  };

  sops.secrets."zjuwlan-credentials" = {};
  users = {
    users.zjuwlan = {
      group = config.users.groups.zjuwlan.name;
      isSystemUser = true;
      home = "/tmp";
      createHome = false;
    };
    groups.zjuwlan = {};
  };

  systemd = {
    timers.zjuwlan-login = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "60s";
        OnUnitInactiveSec = "180s";
        Persistent = true;
        RandomizedDelaySec = "120s";
        Unit = "zjuwlan-login.service";
      };
    };
    services.zjuwlan-login = {
      path = with pkgs; [
        coreutils-full
        curl
        diffutils
        firefox-unwrapped
        gnugrep
        iw
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecCondition = let
          zjuwlan-login-condition = pkgs.writeShellScriptBin "zjuwlan-login-condition" ''
            function current_ssid() {
              iw dev | grep ssid | cut -d' ' -f2
            }
            if cmp -s <(current_ssid | head -c3) <(echo -n ZJU); then
              echo "not connected to ZJUWLAN, skipping"
              exit 1
            fi
            if curl -fsSL https://www.baidu.com/ | grep -q "百度一下"; then
              echo "already logged in, skipping"
              exit 2
            fi
          '';
        in "${zjuwlan-login-condition}/bin/zjuwlan-login-condition";
        RuntimeMaxSec = 90;
        Restart = "on-failure";
        RestartSec = 5;
        User = config.users.users.zjuwlan.name;
        Group = config.users.groups.zjuwlan.name;
        PrivateTmp = true;
        LoadCredential = "credentials:${config.sops.secrets."zjuwlan-credentials".path}";
      };
      script = ''
        cd "$CREDENTIALS_DIRECTORY"
        ${pkgs.zjuwlan-login-script}/bin/zjuwlan
      '';
    };
  };
}
