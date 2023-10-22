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
    networking.wireless = {
      enable = true;
      networks = {
        "ZJUWLAN".authProtocols = [ "NONE" ];
        "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
      };
    };

    systemd.timers.zjuwlan-login = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "60s";
        OnUnitInactiveSec = "180s";
        Persistent = true;
        RandomizedDelaySec = "120s";
        Unit = "zjuwlan-login.service";
      };
    };
    systemd.services.zjuwlan-login = {
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
        cd "$CREDENTIALS_DIRECTORY"
        ${pkgs.zjuwlan-login-script}/bin/zjuwlan
      '';
      serviceConfig = {
        DynamicUser = true;
        RemainAfterExit = true;
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
        LoadCredential = "credentials:${cfg.credentialsFile}";
      };
    };
  };
}
