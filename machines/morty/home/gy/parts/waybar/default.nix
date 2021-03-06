{ config, pkgs, themeColor }: with pkgs; {
  mainBar = {
    posiiton = "top";
    margin-top = 4;
    margin-left = 12;
    margin-right = 12;
    height = 36;
    layer = "top";
    modules-left = [
      "custom/menu"
      "custom/separator"
      "sway/window"
    ];
    modules-center = [
      "sway/workspaces"
      "sway/mode"
      "custom/separator"
      "clock"
      "custom/separator"
      "clock#calendar"
    ];
    modules-right = [
      "backlight"
      "pulseaudio"
      "custom/separator"
      "memory"
      "cpu"
      "custom/separator"
      "network#upload"
      "network#download"
      "custom/separator"
      "tray"
    ];
    "sway/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
      format = "{icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "8" = "";
        "9" = "";
        "10" = "";
        "11" = "";
        "16" = "";
        urgent = "";
        focused = "";
        default = "";
      };
      persistent_workspaces = {
        "1" = [];
      };
    };
    "sway/window" = {
      icon = false;
      rewrite = {
        "^\\[(\\S+)(\\s?.*?)\\s+@ (/.*?)\\] @ (\\w+)$" = "<span foreground='${themeColor "yellow"}'>[</span><span foreground='${themeColor "blue"}'>$1</span>$2 @ <span underline='single'>$3</span><span foreground='${themeColor "yellow"}'>]</span> @ <span weight='bold' foreground='${themeColor "green"}'>$4</span>";
        "^Zellij \\(.*@(.*)\\) - (\\S+)(\\s?.*?)\\s+@ (/.*?)$" = "<span foreground='${themeColor "yellow"}'>[</span><span foreground='${themeColor "blue"}'>$2</span>$3 @ <span underline='single'>$4</span><span foreground='${themeColor "yellow"}'>]</span> @ <span weight='bold' foreground='${themeColor "green"}'>$1</span>";
        "^/home/gy/Zotero/storage/[A-Z0-9]{8}/(.*)$" = "$1";
        "(.*) .*? Mozilla Firefox$" = "$1";
      };
    };
    "sway/mode" = {
      format = "mode: {}";
    };
    tray = {
      icon-size = 20;
      spacing = 10;
      show-passive-items = true;
    };
    clock = {
      timezone = "Asia/Shanghai";
      interval = 1;
      format = "{:%H:%M}";
      tooltip-format = "{:%H:%M:%S}";
      tooltip = true;
    };
    "clock#calendar" = {
      timezone = "Asia/Shanghai";
      interval = 1;
      format = "{:%a, %b.%d}";
      tooltip-format = "<big><span color='${themeColor "green"}'></span> {:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      tooltip = true;
    };
    memory = {
      interval = 5;
      format = "<span color='${themeColor "orange"}'></span> {used:.2f}GiB";
      tooltip-format = "{}% of {total:.1f} GiB used";
      on-click = "${sway}/bin/swaymsg 'workspace 8'";
    };
    cpu = {
      interval = 2;
      format = "<span color='${themeColor "gray"}'></span> {usage}%";
      on-click = "${sway}/bin/swaymsg 'workspace 8'";
    };
    temperature = {
      critical-threshold = 80;
      format = " {icon} {temperatureC}°C";
      format-icons = [
        ""
        ""
        ""
      ];
    };
    backlight = {
      format = "<span color='${themeColor "yellow"}'>{icon}</span> {percent}";
      format-icons = [
        ""
        ""
      ];
      on-scroll-up = "light -A 1";
      on-scroll-down = "light -U 1";
    };
    "group/network" = {
      modules = [
        "network#upload"
        "network#download"
      ];
    };
    "network#download" = {
      interface = "w*";
      interval = 2;
      format = "<span color='${themeColor "green"}'></span> {bandwidthDownBits}";
      format-disconnected = "<span color='${themeColor "red"}'></span>";
      tooltip-format-wifi = " {essid} ({signalStrength}%)\n{ifname}: {ipaddr}/{cidr}";
      tooltip-format-ethernet = " {ifname}: {ipaddr}/{cidr}";
      tooltip-format-linked = " {ifname} (No IP)";
      tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      on-click = "${sway}/bin/swaymsg 'workspace 8'";
    };
    "network#upload" = {
      interface = "w*";
      interval = 2;
      format = "<span color='${themeColor "green"}'></span> {bandwidthUpBits}";
      format-disconnected = "<span color='${themeColor "red"}'></span>";
      tooltip-format-wifi = " {essid} ({signalStrength}%)\n{ifname}: {ipaddr}/{cidr}";
      tooltip-format-ethernet = " {ifname}: {ipaddr}/{cidr}";
      tooltip-format-linked = " {ifname} (No IP)";
      tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      on-click = "${sway}/bin/swaymsg 'workspace 8'";
    };
    pulseaudio = {
      on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +1%";
      on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -1%";
      format = "<span color='${themeColor "purple"}'>{icon}</span> {volume}";
      format-muted = "<span color='${themeColor "red"}'></span>";
      format-bluetooth = "<span color='${themeColor "purple"}'>{icon}</span> {volume}";
      format-bluetooth-muted = "<span color='${themeColor "purple"}'>{icon}</span> <span color='${themeColor "red"}'></span>";
      format-source = " {volume}%";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
          ""
        ];
      };
      on-click = "${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && ${notification-scripts}/bin/volume-notify";
      on-click-right = "${pavucontrol}/bin/pavucontrol";
    };
    "custom/menu" = {
      # format = " ";
      format = " ";
      on-click = "${xfce.thunar}/bin/thunar ~";
      on-click-right = "if systemctl --user is-active gammastep; then systemctl --user stop --no-block gammastep; notify-send --expire-time=3000 'Waybar' 'Stopping gammastep'; else systemctl --user start --no-block gammastep; notify-send --expire-time=3000 'Waybar' 'Starting gammastep'; fi";
      tooltip = false;
    };
    "custom/separator" = {
      format = "|";
      tooltip = false;
    };
  };
}
