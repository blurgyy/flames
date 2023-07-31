{ config, pkgs, ... }:

let
  ntfyHost = "https://ntfy.${config.networking.domain}";
  ntfyTopic = "machines";
in

{
  systemd.services = let
    path = with pkgs; [
      ntfy-sh
      coreutils
    ];
  in {
    machine-status-notify = {
      inherit path;
      documentation = [ "https://docs.ntfy.sh" ];
      serviceConfig = let
        notify = pkgs.writeShellScript "notification" ''
          ntfy publish \
            --tag "$1" \
            --priority "$2" \
            --title "'${config.networking.hostName}' is $3" \
            ${ntfyHost}/${ntfyTopic} \
            "Uptime: $(uptime)"
        '';
      in {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${notify} 'green_circle' 'low' 'spinning up'";
        # ExecReload = "${notify} 'yellow_circle' 'switching system profile'";
        ExecStop = "${notify} 'red_circle' 'default' 'shutting down'";
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };
    poweroff-notify = {
    };
  };
}
