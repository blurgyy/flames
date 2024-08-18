{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.zjuwlan-autoconnect;
in

{
  options.networking.zjuwlan-autoconnect = {
    enable = mkEnableOption "Whether to try to autoconnect to ZJUWLAN when it is the only network reachable";
    credentialsFile = mkOption {
      type = types.str;
      description = ''
        Path to a file containing a `credentials` file required by the `zjuwlan-login-script`
        package
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.zjuwlan-login-script ];

    networking.wireless.networks = {
      "ZJUWLAN".authProtocols = [ "NONE" ];
      "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
    };

    systemd.timers.zjuwlan-login = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10s";
        OnUnitInactiveSec = "30s";
        Persistent = true;
        RandomizedDelaySec = "20s";
        Unit = "zjuwlan-login.service";
      };
    };
    systemd.services.zjuwlan-login = let
      systemdLoadedCredentialFile = "credentials";
    in {
      path = with pkgs; [
        coreutils-full
        curl
        diffutils
        gnugrep
        iw
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.zjuwlan-login-script}/bin/zjuwlan \
          "$CREDENTIALS_DIRECTORY"/${systemdLoadedCredentialFile} \
          /tmp/geckodriver.log
      '';
      environment.HOME = "/tmp";  # geckodriver tries to create $HOME/.config/dconf, default $HOME is set to /var/empty when DynamicUser=true
      serviceConfig = {
        DynamicUser = true;
        RemainAfterExit = false;
        ExecCondition = let
          zjuwlan-login-condition = pkgs.writeShellScriptBin "zjuwlan-login-condition" ''
            function current_ssid() {
              iw dev | grep ssid | grep ZJU | cut -d' ' -f2
            }
            if ! cmp -s <(current_ssid | head -c3) <(echo -n ZJU); then
              echo "not connected to ZJUWLAN, skipping"
              exit 1
            fi
            if curl -fsSL https://www.baidu.com/ --connect-timeout 5 | grep -q "百度一下"; then
              echo "network is already reachable, skipping"
              exit 2
            fi
            echo "not logged in, logging in"
          '';
        in "${zjuwlan-login-condition}/bin/zjuwlan-login-condition";
        RuntimeMaxSec = 90;
        Restart = "on-failure";
        RestartSec = 5;
        PrivateTmp = true;
        # PrivateTmp = false;  # disable PrivateTmp for debugging, geckodriver's log is written to /tmp/geckodriver.log (see the `zjuwlan` script)
        LoadCredential = "${systemdLoadedCredentialFile}:${cfg.credentialsFile}";
      };
    };
  };
}
