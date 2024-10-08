{ config, lib, pkgs, __callWithHelpers, ... }:

let
  inherit (config.ricing) themeColor;
  callWithHelpers = f: override: __callWithHelpers f (override // { inherit config callWithHelpers; });
  wm-session-wants = [
    "thunar.service"
    "systembus-notify.service"
  ];
  themeColorHex = name: builtins.replaceStrings [ "#" ] [ "" ] (themeColor name);
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig = let
      topprg = "${pkgs.btop}/bin/btop";
      hypr-execonce-helper = "${pkgs.hypr-execonce-helper}";
      hypr-last-workspace-recorder = "${pkgs.hypr-last-workspace-recorder}";
      backlight-notify = "${pkgs.notification-scripts}/bin/backlight-notify";
      volume-notify = "${pkgs.notification-scripts}/bin/volume-notify";
      screenshot-notify = "${pkgs.notification-scripts}/bin/screenshot-notify";
    in ''
      exec-once = systemctl --user reset-failed
      exec-once = hyprctl setcursor ${with config.home.pointerCursor; "${name} ${toString size}"}
      exec-once = ${lib.getExe pkgs.setup-xdg-desktop-portal-env-script} Hyprland

      # Record last workspace for later use with $mainMod+tab
      exec-once = sdwrap -- ${hypr-last-workspace-recorder}

      # REF: <https://wiki.hyprland.org/Configuring/Monitors/>
      monitor=desc:Philips Consumer Electronics Company PHL275E9 0x000023C6,2560x1440@74.968002,auto,1
      monitor=desc:LGD 0x0519,1920x1080@60.020000,auto,1
      monitor=,preferred,auto,1

      $mainMod = SUPER

      # Workspace assignments for applications that does not autostart on hyprland launch
      windowrulev2 = workspace 2, class:^chromium-browser$
      windowrulev2 = workspace 10, class:^(telegramdesktop|org.telegram.desktop)$
      windowrulev2 = workspace 16 silent, class:^Steam$
      windowrulev2 = workspace 32 silent, class:^minecraft-launcher$

      # Terminal on first workspace, don't sdwrap this one
      exec-once = alacritty

      # Firefox on workspace 2
      windowrulev2 = workspace 2 silent, class:^firefox$
      exec-once = sdwrap -- firefox
      # Knowledge garden application on workspace 3
      windowrulev2 = workspace 3, class:^(Logseq|obsidian)$
      exec-once = sdwrap -- obsidian
      # System monitor on workspace 8
      windowrulev2 = workspace 8 silent, class:^sysmon$
      exec-once = ALACRITTY_SOCK="/dev/shm/$WAYLAND_DISPLAY-topprg-workspace8.sock" sdwrap -- alacritty --class sysmon -e sh -c 'while true; do echo "I: starting ${topprg}"; if ! ${topprg}; then echo "E: ${topprg} was closed unexpectedly" >&2; else echo "I: ${topprg} was closed successfully"; fi done'
      # Zotero on workspace 9
      windowrulev2 = workspace 9 silent, class:^Zotero$
      exec-once = sdwrap -- zotero

      # Use exec here to always reset the window rules at each config reload
      exec = ${hypr-execonce-helper} ${lib.concatStringsSep " " (map
        ({ class-name, rule ? "class:^${class-name}$", workspace}: "--class-name='${class-name}' --rule='${rule}' --workspace='${toString workspace}'")
        [ { class-name = "firefox"; workspace = 2; }
          { class-name = "sysmon"; workspace = 8; }
          { class-name = "Zotero"; workspace = 9; } ]
      )}

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # For all categories, see <https://wiki.hyprland.org/Configuring/Variables/>
      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_rules =
        repeat_delay = 500  # Start repeating keys after 500 ms
        repeat_rate = 30  # Larger value results in higher recurring rate while repeating keys

        # 0 - Cursor movement will not change focus.
        # 1 - Cursor movement will always change focus to the window under the cursor.
        # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
        # 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
        follow_mouse = 2

        touchpad {
          disable_while_typing = true
          middle_button_emulation = true
          natural_scroll = true
          scroll_factor = 0.25
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        accel_profile = flat
      }
      # REF: <https://wiki.hyprland.org/Configuring/Keywords/#executing>
      device:catex-tech.-68ec-s {
        kb_file = ${pkgs.niz-68ec-use-sun_unix-layout-keymaps}/share/kbd/keymap.xkb
      }
      device:at_translated_set_2_keyboard {
        kb_file = ${pkgs.hp-omen-use-sun_unix-layout-keymaps}/share/kbd/keymap.xkb
      }
      device:synps/2-synaptics-touchpad {
        natural_scroll = true
        accel_profile = adaptive
      }

      general {  # REF: <https://wiki.hyprland.org/Configuring/Variables/>
        gaps_in = 2
        gaps_out = 8
        border_size = 3

        col.active_border = rgba(${themeColorHex "highlight"}ee)
        col.inactive_border = rgba(${themeColorHex "gray"}aa)
        col.nogroup_border_active = rgba(${themeColorHex "orange"}ee)
        col.nogroup_border = rgba(${themeColorHex "gray"}aa)

        layout = dwindle
        resize_on_border = true
        apply_sens_to_raw = true
        cursor_inactive_timeout = 0  # Disable hiding cursor
        no_cursor_warps = true  # Do not jump the cursor when switching focus to another window
      }

      misc {
        disable_hyprland_logo = true
        layers_hog_keyboard_focus = true  # Keep focus on keyboard-interactive layers (rofi) on mouse move
      }

      binds {
        allow_workspace_cycles = true
        workspace_back_and_forth = false  # obsolete with hypr-last-workspace-recorder
      }

      decoration {
        # See <https://wiki.hyprland.org/Configuring/Variables/> for more

        rounding = 6

        # <https://wiki.hyprland.org/hyprland-wiki/pages/Configuring/Variables/#blur>
        blur {
          enabled = true
          size = 13
          passes = 3
          ignore_opacity = false
          new_optimizations = true
          xray = true
        }

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(${themeColorHex "black"}ee)

        active_opacity = 1
        inactive_opacity = .8
      }

      animations {
        enabled = true

        # Some default animations, see <https://wiki.hyprland.org/Configuring/Animations/> for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 3, default, popin
        # animation = windowsOut, 1, 2, default, popin 80%
        animation = border, 1, 5, default
        animation = fade, 1, 2, default
        animation = workspaces, 1, 3, default, slide
      }

      dwindle {
        # See <https://wiki.hyprland.org/Configuring/Dwindle-Layout/> for more
        pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # you probably want this
        # 0: open new split window at mouse location
        # 1: always left/top
        # 2: always right/bottom
        force_split = 2
      }

      master {
        # See <https://wiki.hyprland.org/Configuring/Master-Layout/> for more
        new_is_master = true
      }

      gestures {
        # See <https://wiki.hyprland.org/Configuring/Variables/> for more
        workspace_swipe = true
        workspace_swipe_distance = 500
        workspace_swipe_min_speed_to_force = 20
        workspace_swipe_forever = true
        workspace_swipe_create_new = false
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # REF: <https://wiki.hyprland.org/Configuring/Window-Rules/>
      windowrulev2 = float, class:^(Thunar|org.fcitx.fcitx5-config-qt|flameshot|kvantummanager|qt5ct|pavucontrol|swappy|zenity|CrashReportClient)$
      windowrulev2 = float, class:firefox, title:^(Picture-in-Picture|Library|Extension: .*|Close Firefox|Firefox (-|—) (Choose User Profile|Sharing Indicator)|(Delete|Rename) Profile|Create Profile Wizard)$
      windowrulev2 = float, class:Steam, title:Steam Login|Friends List|好友列表|Music Player|Allow game launch?|Steam - (Self Updater|News.*)
      windowrulev2 = float, class:steam_app_\d{6}, title:Uplay|LariLauncher
      windowrulev2 = float, class:^CloudCompare$, title:Ply File Open
      windowrulev2 = float, class:^org\.kde\.kdeconnect\.*$, title:Ply File Open
      windowrulev2 = float, class:com.alibabainc.dingtalk, title: |分享的图片
      windowrulev2 = float, class:mpv
      windowrulev2 = float, class:alarm-clock-applet
      windowrulev2 = float, class:localsend_app
      windowrulev2 = float, class:blender, title:Blender (Preferences|Render)
      windowrulev2 = float, class:vimiv

      windowrulev2 = pin, floating:1

      # Bindings
      # REF: <https://wiki.hyprland.org/Configuring/Keywords/>

      bind = $mainMod ALT, Q, exit,

      # REF: <https://wiki.hyprland.org/Configuring/Binds/>
      bind = $mainMod, return, exec, alacritty
      bind = $mainMod, w, killactive,
      bind = $mainMod, y, exec, waypoint
      bind = $mainMod, e, exec, thunar
      bind = $mainMod, r, exec, rofi -show drun
      bind = ALT SHIFT, r, exec, rofi -show run
      bind = ALT, s, exec, rofi -show ssh
      bind = ALT SHIFT, s, exec, rofi -ssh-client 'waypipe --remote-bin=~/.nix-profile/bin/waypipe ssh -Y' -show ssh
      # bind = $mainMod, e, pseudo, # dwindle
      # bind = $mainMod, e, togglesplit, # dwindle

      bind = $mainMod, f, togglefloating,
      bind = ALT, return, fullscreen, 0
      bind = $mainMod, m, fullscreen, 1

      bind = $mainMod, p, togglesplit,
      bind = $mainMod, g, togglegroup,
      bind = $mainMod, period, changegroupactive, f
      bind = $mainMod, comma, changegroupactive, b
      bind = $mainMod CTRL, h, moveintogroup, l
      bind = $mainMod CTRL, j, moveintogroup, d
      bind = $mainMod CTRL, k, moveintogroup, u
      bind = $mainMod CTRL, l, moveintogroup, r

      # Xf86
      binde = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5 && ${backlight-notify}
      binde = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5 && ${backlight-notify}
      binde = , XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && ${volume-notify}
      binde = , XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && ${volume-notify}
      bind = , XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && ${volume-notify}

      # Screenshot
      bind = $mainMod SHIFT, x, exec, ${screenshot-notify} pixel
      bind = $mainMod SHIFT, s, exec, ${screenshot-notify} region
      bind = $mainMod SHIFT, d, exec, ${screenshot-notify} delegate
      bind = $mainMod SHIFT, p, exec, ${screenshot-notify} full
      bind = , print, exec, ${screenshot-notify} full

      # Lid switch, use hyprctl devices to show name
      bind = , switch:Lid Switch, exec, sdwrap -- swaylock

      bind = $mainMod ALT, L, exec, sdwrap -- swaylock
      bind = $mainMod ALT, N, exec, swaync-client -t

      # Move focus within current workspace
      bind = $mainMod, left,  movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up,    movefocus, u
      bind = $mainMod, down,  movefocus, d
      bind = $mainMod, h,     movefocus, l
      bind = $mainMod, j,     movefocus, d
      bind = $mainMod, k,     movefocus, u
      bind = $mainMod, l,     movefocus, r
      bind = $mainMod, space, cyclenext,
      bind = $mainMod SHIFT, space, cyclenext, previous

      # Move focused window within current workspace
      bind = $mainMod SHIFT, left,  movewindow, l
      bind = $mainMod SHIFT, right, movewindow, r
      bind = $mainMod SHIFT, up,    movewindow, u
      bind = $mainMod SHIFT, down,  movewindow, d
      bind = $mainMod SHIFT, h,     movewindow, l
      bind = $mainMod SHIFT, j,     movewindow, d
      bind = $mainMod SHIFT, k,     movewindow, u
      bind = $mainMod SHIFT, l,     movewindow, r

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      bind = $mainMod, minus, togglespecialworkspace,

      # Relative **active** workspace navigating
      bind = $mainMod, tab, exec, hyprctl dispatch workspace $(cat /tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.last-workspace)
      # Relative **active** workspace navigating
      bind = $mainMod, bracketleft, workspace, e-1
      bind = $mainMod, bracketright, workspace, e+1

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10
      bind = $mainMod SHIFT, minus, movetoworkspace, special

      # Relative workspace assigning
      bind = $mainMod SHIFT, bracketleft, movetoworkspace, -1
      bind = $mainMod SHIFT, bracketright, movetoworkspace, +1

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Resizing using submap, REF: <https://wiki.hyprland.org/Configuring/Binds/#submaps>
      bind = $mainMod, a, submap, resize
      submap = resize
      binde = , h, resizeactive, -10 0
      binde = , j, resizeactive, 0 10
      binde = , k, resizeactive, 0 -10
      binde = , l, resizeactive, 10 0
      bind = , escape, submap, reset
      bind = , space, submap, reset
      bind = , return, submap, reset
      submap = reset
    '';
  };

  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };

  systemd.user = {
    targets.hyprland-session.Unit.Wants = lib.mkIf config.wayland.windowManager.hyprland.enable wm-session-wants;
    services = {
      hyprpaper = {
        Unit.X-Restart-Triggers = [ (with builtins; hashString "sha512" (callWithHelpers ./mirrored/headful/hypr/hyprpaper.conf.asnix {})) ];
        Service = {
          ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
          Restart = "always";
          RestartSec = 1;
        };
        Install.WantedBy = [ "hyprland-session.target" ];
      };
      waybar.Install.WantedBy = [ "hyprland-session.target" ];
    };
  };
}
