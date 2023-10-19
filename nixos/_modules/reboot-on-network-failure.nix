{ config, lib, pkgs, ... }:

{
  options.networking.reboot-on-network-failure = lib.mkEnableOption ''
    Reboot machine if network has been unreachable after a certain number of retries.
  '';
  config = lib.mkIf config.networking.reboot-on-network-failure {
    systemd.timers.reboot-on-network-failure = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "300s";
        OnUnitInactiveSec = "150s";
        Persistent = true;
        RandomizedDelaySec = "60s";
        Unit = "reboot-on-network-failure.service";
      };
    };
    systemd.services.reboot-on-network-failure = {
      path = with pkgs; [
        curl
        gnugrep
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
        ExecCondition = let
          network-failure-condition = pkgs.writeShellScriptBin "network-failure-condition" ''
            for ((i=1; i<=3; ++i)); do
              if curl -fsSL https://www.baidu.com/ --connect-timeout 10 | grep -q "百度一下"; then
                echo "network is up and running, skipping"
                exit 1
              fi
              echo "network is down ($i/3), retrying in 20s"
              sleep 20s
            done
            echo "network failure detected, rebooting"
          '';
        in "${network-failure-condition}/bin/network-failure-condition";
      };
    };
  };
}
