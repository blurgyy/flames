{ pkgs, ... }: {
  systemd.services = let
    ExecCondition = pkgs.writeShellScript "is-connected-to-zjuwlan" ''
      function current_ssid() {
        iw dev | grep ssid | grep ZJU | cut -d' ' -f2
      }
      if ! cmp -s <(current_ssid | head -c3) <(echo -n ZJU); then
        echo >&2 "not connected to ZJUWLAN, skipping"
        exit 1
      else
        echo "connected to ZJUWLAN"
      fi
    '';
    path = with pkgs; [ iw diffutils gnugrep coreutils];
  in {
    rp-http-proxy = {
      inherit path;
      serviceConfig = { inherit ExecCondition; };
    };
    rp-socks-proxy = {
      inherit path;
      serviceConfig = { inherit ExecCondition; };
    };
  };

  systemd.timers = let
    wantedBy = [ "timers.target" ];
    sharedTimerConfig = {
      OnCalendar = "*-*-* *:*:00";  # minutely
      Persistent = "yes";
    };
  in {
    rp-http-proxy = {
      inherit wantedBy;
      timerConfig = sharedTimerConfig // {
        Unit = "rp-http-proxy.service";
      };
    };
    rp-socks-proxy = {
      inherit wantedBy;
      timerConfig = sharedTimerConfig // {
        Unit = "rp-socks-proxy.service";
      };
    };
  };
}
