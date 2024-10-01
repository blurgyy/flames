{ config, lib, pkgs, ... }:

let
  cfg = config.networking.reboot-on-network-failure;
in

{
  options.networking.reboot-on-network-failure = with lib; {
    enable = mkEnableOption ''
      Reboot machine if network has been unreachable after a certain number of retries.
    '';
    packages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [ iputils ];
      description = "added to the environment of the systemd service for checking if internet is connected";
    };
    command = mkOption {
      type = types.str;
      default = ''
        if ping -c 1 223.5.5.5 &>/dev/null; then
          return 0
        fi
        ping -W 1 -c 10 223.5.5.5 &>/dev/null
      '';
      description = "written to the body of a bash function.  should only return 0 if network is reachable";
    };
    retries = mkOption {
      type = types.int;
      default = 3;
      description = "retry for this times, if all retries failed, reboot";
    };
    retryInterval = mkOption {
      type = types.str;
      default = "20s";
      description = "retry every such number of seconds, should be interpretable by the sleep(1) command-line utility";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.timers.reboot-on-network-failure = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "300s";
        OnUnitInactiveSec = "240s";
        Persistent = true;
        RandomizedDelaySec = "60s";
        Unit = "reboot-on-network-failure.service";
      };
    };
    systemd.services.reboot-on-network-failure = {
      path = cfg.packages;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
        ExecCondition = let
          network-failure-condition = pkgs.writeShellScriptBin "network-failure-condition" ''
            function network_is_reachable() {
              ${cfg.command}
            }

            i=0
            while true; do
              i=$((i + 1))
              if network_is_reachable; then
                echo "network is up and running, skipping"
                exit 1
              fi
              echo "network is down ($i/${toString cfg.retries})"
              if [[ $i -ge ${toString cfg.retries} ]]; then
                break
              fi
              echo "retrying in ${cfg.retryInterval}"
              sleep ${cfg.retryInterval}
            done
            echo "network failure detected, rebooting"
          '';
        in "${network-failure-condition}/bin/network-failure-condition";
      };
    };
  };
}
