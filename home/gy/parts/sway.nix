{ pkgs, config, themeColor }: let
  terminal = "${pkgs.alacritty-swarm}/bin/alacritty";
  forest = pkgs.fetchurl {
    url = "https://i.redd.it/a8kxowakxbe81.jpg";
    name = "forest.jpg";
    sha256 = "sha256-DINHeFo3VZbgVEUlJ/lvThvR5KWRXyKoNo6Eo2jLYDw=";
  };
  bgimg = forest;
in {
  enable = true;
  xwayland = true;
  wrapperFeatures.gtk = true;
  config = {
    modifier = "Mod4";
    left = "h";
    down = "j";
    up = "k";
    right = "l";
    defaultWorkspace = "workspace number 1";
    terminal = "${terminal}";
    startup = let 
      topprg = "${pkgs.btop}/bin/btop";
    in [
      { command = "systemctl --user reset-failed"; }
      { command = "${terminal} --class sway_autostart_alacritty"; }
      { command = "firefox"; }
      { command = "zotero"; }
      { command = ''
        ALACRITTY_SOCK="/dev/shm/$WAYLAND_DISPLAY-topprg-workspace8.sock" ${terminal} --class sysmon -e sh -c 'while true; do echo "I: starting ${topprg}"; if ! ${topprg}; then echo "E: ${topprg} was closed unexpectedly" >&2; else echo "I: ${topprg} was closed successfully"; fi done'
        ''; }
    ];
    keybindings = let
      term = config.wayland.windowManager.sway.config.terminal;
      mod = config.wayland.windowManager.sway.config.modifier;
      left = config.wayland.windowManager.sway.config.left;
      down = config.wayland.windowManager.sway.config.down;
      up = config.wayland.windowManager.sway.config.up;
      right = config.wayland.windowManager.sway.config.right;
      rofi = "${pkgs.rofi-wayland}/bin/rofi";
      fm = "${pkgs.xfce.thunar}/bin/thunar ~";
      backlight-notify = "${pkgs.notification-scripts}/bin/backlight-notify";
      volume-notify = "${pkgs.notification-scripts}/bin/volume-notify";
      screenshot-notify = "${pkgs.notification-scripts}/bin/screenshot-notify";
    in {
      "${mod}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
      "${mod}+Alt+q" =  "exec swaymsg exit";
      "${mod}+e" = "exec ${fm}";
      "${mod}+w" = "kill";

      # Launchers
      "Alt+s" = "exec ${rofi} -terminal ${term} -show ssh";
      "Alt+r" = "exec ${rofi} -terminal ${term} -show drun";
      "Alt+Shift+r" = "exec ${rofi} -terminal ${term} -show run";

      # Screenshots
      "${mod}+Shift+x" = "exec ${screenshot-notify} pixel";
      "${mod}+Shift+s" = "exec ${screenshot-notify} region";
      "${mod}+Shift+d" = "exec ${screenshot-notify} delegate";
      "${mod}+Shift+p" = "exec ${screenshot-notify} full";
      "Print" = "exec ${screenshot-notify} full";

      # Brightness & Volume control
      "XF86MonBrightnessUp" = ''
        exec ${pkgs.light}/bin/light -A 5 && \
          exec ${backlight-notify}
      '';
      "XF86MonBrightnessDown" = ''
        exec ${pkgs.light}/bin/light -U 5 && \
          exec ${backlight-notify}
      '';
      "XF86AudioRaiseVolume" = ''
        exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && \
          exec ${volume-notify}
      '';
      "XF86AudioLowerVolume" = ''
        exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && \
          exec ${volume-notify}
      '';
      "XF86AudioMute" = ''
        exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && \
          exec ${volume-notify}
      '';

      # Moving focus within workspace
      "${mod}+${left}" = "focus left";
      "${mod}+${down}" = "focus down";
      "${mod}+${up}" = "focus up";
      "${mod}+${right}" = "focus right";
      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";

      # Moving focused container within workspace
      "${mod}+Shift+${left}" = "move left";
      "${mod}+Shift+${down}" = "move down";
      "${mod}+Shift+${up}" = "move up";
      "${mod}+Shift+${right}" = "move right";
      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Right" = "move right";

      # Move focused container(s)
      "${mod}+Shift+1" = "move container to workspace number 1";
      "${mod}+Shift+2" = "move container to workspace number 2";
      "${mod}+Shift+3" = "move container to workspace number 3";
      "${mod}+Shift+4" = "move container to workspace number 4";
      "${mod}+Shift+5" = "move container to workspace number 5";
      "${mod}+Shift+6" = "move container to workspace number 6";
      "${mod}+Shift+7" = "move container to workspace number 7";
      "${mod}+Shift+8" = "move container to workspace number 8";
      "${mod}+Shift+9" = "move container to workspace number 9";
      "${mod}+Shift+0" = "move container to workspace number 10";

      # Switching workspaces
      "${mod}+1" = "workspace number 1";
      "${mod}+2" = "workspace number 2";
      "${mod}+3" = "workspace number 3";
      "${mod}+4" = "workspace number 4";
      "${mod}+5" = "workspace number 5";
      "${mod}+6" = "workspace number 6";
      "${mod}+7" = "workspace number 7";
      "${mod}+8" = "workspace number 8";
      "${mod}+9" = "workspace number 9";
      "${mod}+0" = "workspace number 10";
      "${mod}+bracketleft" = "workspace prev";
      "${mod}+bracketright" = "workspace next";
      "${mod}+Tab" = "workspace back_and_forth";

      # Layout manipulating
      "${mod}+v" = "split horizontal";
      "${mod}+n" = "split vertical";
      "${mod}+b" = "split none";
      "${mod}+m" = "layout toggle tabbed split";
      "${mod}+p" = "layout toggle split";
      "${mod}+f" = "fullscreen";
      "${mod}+s" = "floating toggle";
      "${mod}+Shift+Space" = "layout stacking";

      # Toggle current focus between tiling and floating mode
      "${mod}+Space" = "focus mode_toggle";
      "${mod}+o" = "focus parent";
      "${mod}+i" = "focus child";

      # Scratchpad
      "${mod}+minus" = "scratchpad show";
      "${mod}+Shift+minus" = "move scratchpad";

      "${mod}+Escape" = "exec swaylock";

      "${mod}+r" = ''mode "resize"'';
    };
    modes.resize = with config.wayland.windowManager.sway.config; {
      "${left}" = "resize shrink width 10px";
      "${down}" = "resize grow height 10px";
      "${up}" = "resize shrink height 10px";
      "${right}" = "resize grow width 10px";
      "Left" = "resize shrink width 10px";
      "Down" = "resize grow height 10px";
      "Up" = "resize shrink height 10px";
      "Right" = "resize grow width 10px";

      "Return" = ''mode "default"'';
      "Escape" = ''mode "default"'';
      "Space" = ''mode "default"'';
      "${modifier}+r" = ''mode "default"'';
    };
    assigns = {
      "1" = [
        { app_id = "sway_autostart_alacritty"; }
      ];
      "2" = [
        { app_id = "firefox"; }
        { class = "firefox"; }
      ];
      "3" = [
        { class = "Logseq"; }
      ];
      "6" = [
        { app_id = "UE4Editor|CrashReportClient"; }
      ];
      "8" = [
        { app_id = "sysmon"; }
      ];
      "9" = [
        { class = "Zotero"; }
      ];
      "10" = [
        { class = "TelegramDesktop|Element|discord|com.alibabainc.dingtalk|weixin"; }
        { app_id = "telegramdesktop"; }
      ];
      "11" = [
        { class = "GStreamer"; title = "rpiplay"; }
      ];
      "16" = [
        { class = "Steam"; }
        { title = "Steam"; }
      ];
    };
    floating = {
      criteria = [
        { app_id = "CloudCompare"; title = "Ply File Open"; }
        { class = "com.alibabainc.dingtalk"; title = " |分享的图片"; }
        { app_id = "org.fcitx.fcitx5-config-qt|flameshot|kvantummanager|qt5ct|pavucontrol|swappy|zenity|CrashReportClient"; }
        {
          app_id = "firefox";
          title = "^(Picture-in-Picture|Library|Extension: .*|Close Firefox|Firefox - Choose User Profile|(Delete|Rename) Profile|Create Profile Wizard)$";
        }
        { class = "Zotero"; title = "Software Update"; }
        {
          class = "Steam";
          title = "Steam Login|Friends List|Music Player|Allow game launch\\\\?|Steam - (Self Updater|News.*)";
        }
        {
          class = "steam_app_\\\\d{6}";
          title = "Uplay|LariLauncher";
        }
        { app_id = "Thunar"; title = "^.+$"; }
        { title = "https:\/\/space.dingtalk.com\/attachment\/mdown.*"; }
      ];
    };
    window.commands = [
      { criteria = { floating = true; }; command = "sticky enable, border csd"; }
      { criteria = { app_id = "pavucontrol"; }; command = "resize set width 480 px height 640px, move position cursor, move down 35"; }
      { criteria = { app_id = "Thunar"; }; command = "move position center"; }
      { criteria = { app_id = "Thunar"; title = "^.+[^( - Properties)]$"; }; command = "resize set width 1280px height 936px"; }
    ];
    colors = {
      focused = {
        border = themeColor "orange";
        background = themeColor "blue";
        text = themeColor "background";
        indicator = themeColor "green";
        childBorder = themeColor "white";
      };
      unfocused = {
        border = themeColor "darkgray";
        background = themeColor "background";
        text = themeColor "foreground";
        indicator = themeColor "orange";
        childBorder = themeColor "gray";
      };
      urgent = {
        border = themeColor "red";
        background = themeColor "orange";
        text = themeColor "background";
        indicator = themeColor "purple";
        childBorder = themeColor "red";
      };
      focusedInactive = {
        border = themeColor "black";
        background = themeColor "lightgray";
        text = themeColor "foreground";
        indicator = themeColor "lightgray";
        childBorder = themeColor "black";
      };
    };
    # Cursor theme and size.  Note that according to man:sway(1)#ENVIRONMENT, environment variables
    # "XCURSOR_THEME" and "XCURSOR_SIZE" are **set** by sway instead of having an effect on sway, so
    # setting XCURSOR_THEME/XCURSOR_SIZE outside sway cannot change the cursor's appearance in any
    # way.  Below line is documented from man:sway-input(5).
    seat."*" = {
      xcursor_theme = "${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}";
    };
    input = {
      "type:touchpad" = {
        accel_profile = "adaptive";  # Available values: (adaptive|flat)
        dwt = "enabled";  # Enable "disable-while-typing" feature
        tap = "enabled";  # Accept tap as mouse click
        natural_scroll = "enabled";  # Like dragging a page as paper
        # natural_scroll = false  # Like dragging a page's scrollbar
        scroll_factor = "0.25";
        middle_emulation = "enabled";  # Enable middle click emulation
        tap_button_map = "lrm";  # left(1 finger) right(2 finger) middle(3 finger)
      };
      "type:keyboard" = {
        repeat_delay = "500";  # Start repeating keys after 500 ms
        repeat_rate = "30";  # Larger value results in higher recurring rate while repeating keys
        xkb_options = "caps:escape";
      };
      "1155:20786:CATEX_TECH._68EC-S".xkb_file = toString pkgs.niz-68ec-keymap;
    };
    fonts = {
      names = [ "slab-serif" ];
      style = "normal";
      size = 0.0;
    };
    gaps = {
      inner = 4;
      outer = 8;
      vertical = 0;
    };
    output = {
      "*" = {
        bg = "${bgimg} fill";
        subpixel = "none";
        adaptive_sync = "off";
      };
      eDP-1 = { };
      "Philips Consumer Electronics Company PHL275E9 0x000023C6" = {
        mode = "2560x1440@74.968Hz";
      };
    };
    bars = [ ];
  };
  extraConfig = ''
    bindswitch lid:on exec swaylock
    titlebar_border_thickness 3
    titlebar_padding 3 3
  '';
  config.window.border = 6;
}
