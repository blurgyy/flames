{ pkgs, hostName, config }: with pkgs; let
  inherit (config.ricing) themeColor;
  ethernetInterface.winston = "eth0";
  wirelessInterface.morty = "wlan0";
  interface = if (builtins.hasAttr hostName ethernetInterface)
    then ethernetInterface.${hostName}
    else if (builtins.hasAttr hostName wirelessInterface)
    then wirelessInterface.${hostName}
    else "*";
  workspaceModule = {
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
    persistent-workspaces = {
      "1" = [];
    };
    active-only = false;  # whether to show only focused workspace
    sort-by-number = true;
    on-click = "activate";
  };
  windowModule = {
    icon = false;
    rewrite = {
      "^\\[(\\S+)(\\s?.*?)\\s+@ (/.*?)\\] @ ([\\w\\-_\\.]+)$" = "<span weight='bold' foreground='${themeColor "green"}'>$4</span>:<span foreground='${themeColor "yellow"}'>[</span><span foreground='${themeColor "blue"}'>$1</span>$2 @ <span underline='single'>$3</span><span foreground='${themeColor "yellow"}'>]</span>";
      "^Zellij \\(.*@(.*)\\) - (\\S+)(\\s?.*?)\\s+@ (/.*?)$" = "<span weight='bold' foreground='${themeColor "green"}'>$1</span><span foreground='${themeColor "yellow"}'>[</span><span foreground='${themeColor "blue"}'>$2</span>$3 @ <span underline='single'>$4</span><span foreground='${themeColor "yellow"}'>]</span>";
      "^/home/gy/Zotero/storage/[A-Z0-9]{8}/(.*)$" = "$1";
      "(.*) .*? Mozilla Firefox$" = "$1";
    };
  };
in {
  mainBar = {
    posiiton = "top";
    margin-top = 4;
    margin-left = 12;
    margin-right = 12;
    height = 42;
    layer = "top";
    modules-left = [
      "custom/menu"
      "custom/separator"
      "sway/window"
    ] ++ lib.optional config.wayland.windowManager.hyprland.enable "hyprland/window";
    modules-center = lib.optional config.wayland.windowManager.hyprland.enable "hyprland/workspaces" ++ [
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
    "hyprland/workspaces" = workspaceModule;
    "sway/workspaces" = workspaceModule;
    "sway/window" = windowModule;
    "hyprland/window" = windowModule;
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
      tooltip-format = "<big><span color='${themeColor "green"}'></span> {:%B,%Y}</big>\n<tt><small>{calendar}</small></tt>";
      tooltip = true;
      calendar = {
        mode = "year";
        mode-mon-col = 3;
        weeks-pos = "left";
        on-scroll = 1;
        on-click-right = "mode";
        format = {
          months = "<span color='${themeColor "foreground"}'><b>{}</b></span>";
          days = "<span color='${themeColor "pink"}'><b>{}</b></span>";
          weeks = "<span color='${themeColor "gray"}'><b>W{}</b></span>";
          weekdays = "<span color='${themeColor "yellow"}'><b>{}</b></span>";
          today = "<span color='${themeColor "lavender"}'><b><u>{}</u></b></span>";
        };
      };
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
      tooltip = false;
      format = "<span color='${themeColor "yellow"}'>{icon}</span> {percent}";
      format-icons = [
        ""
        ""
      ];
      on-scroll-up = "${light}/bin/light -A 1";
      on-scroll-down = "${light}/bin/light -U 1";
    };
    "group/network" = {
      modules = [
        "network#upload"
        "network#download"
      ];
    };
    "network#download" = {
      inherit interface;
      interval = 2;
      format = "<span color='${themeColor "green"}'></span> {bandwidthDownBytes}";
      format-disconnected = "<span color='${themeColor "red"}'></span>";
      tooltip-format-wifi = " {essid} ({signalStrength}%)\n{ifname}: {ipaddr}/{cidr}";
      tooltip-format-ethernet = " {ifname}: {ipaddr}/{cidr}";
      tooltip-format-linked = " {ifname} (No IP)";
      tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      on-click = "${sway}/bin/swaymsg 'workspace 8'";
    };
    "network#upload" = {
      inherit interface;
      interval = 2;
      format = "<span color='${themeColor "green"}'></span> {bandwidthUpBytes}";
      format-disconnected = "<span color='${themeColor "red"}'></span>";
      tooltip-format-wifi = " {essid} ({signalStrength}%)\n{ifname}: {ipaddr}/{cidr}";
      tooltip-format-ethernet = " {ifname}: {ipaddr}/{cidr}";
      tooltip-format-linked = " {ifname} (No IP)";
      tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      on-click = "${sway}/bin/swaymsg 'workspace 8'";
    };
    pulseaudio = {
      on-click = "${pavucontrol}/bin/pavucontrol";
      on-click-right = "${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && ${notification-scripts}/bin/volume-notify";
      on-scroll-up = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
      on-scroll-down = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
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
    };
    "custom/menu" = {
      # format = " ";
      format = " ";
      on-click = "${xfce.thunar}/bin/thunar ~";
      on-click-right = "if systemctl --user is-active gammastep; then systemctl --user stop --no-block gammastep; ${pkgs.libnotify}/bin/notify-send --expire-time=3000 'Waybar' 'Stopping gammastep'; else systemctl --user start --no-block gammastep; ${pkgs.libnotify}/bin/notify-send --expire-time=3000 'Waybar' 'Starting gammastep'; fi";
      tooltip = false;
    };
    "custom/separator" = {
      format = "|";
      tooltip = false;
    };
  };
}
