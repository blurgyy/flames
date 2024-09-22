{ config }: let
  inherit (config.ricing) themeColor;
in ''
  set command_status "$status"
  set notify_threshold 30000
  set notification_timeout 30000

  if set -q CMD_DURATION
    if test "$CMD_DURATION" -gt "$notify_threshold"
      # Get actual name of previous executable
      for command_name in (string split -- " " "$argv[1]")
        if not string match -qr -- '^(;|sudo|bagex|command|-.*)$' "$command_name"
          break
        end
      end

      # Ignore these commands, namely:
      #   - bat (cat, mdcat)
      #   - fg
      #   - ghc
      #   - git
      #   - gpustat
      #   - htop (btm, btop, bpytop, iotop, radeontop, top)
      #   - julia
      #   - less (more)
      #   - man
      #   - mpv
      #   - nvim (vim)
      #   - python (ipython, bpython)
      #   - qalc
      #   - systemctl (journalctl)
      #   - systemd-cgls
      #   - systemd-cgtop
      #   - watch
      if string match --quiet --regex -- \
          '^((mdc|[bc])at|fg|ghc|git|gpustat|(btm|([hb]|bpy|io|radeon)?top)|julia|(less|more)|man|mpv|n?vim|[bi]?python|qalc|sops|(system|journal)ctl|systemd-cg(ls|top)|watch)$' \
          "$command_name"
        return
      end

      # Highlight and format command body
      set command_body \
        "<u><tt><b>$argv[1]</b></tt></u>"

      # Highlight return status
      if test "$command_status" -eq 0
        set command_status \
          "<span foreground='${themeColor "green"}'><tt><b>$command_status</b></tt></span>"
        set icon_name dialog-information
      else
        set command_status \
          "<span foreground='${themeColor "red"}'><tt><b>$command_status</b></tt></span>"
        set icon_name dialog-warning
      end

      # Highlight and format running time
      set command_duration \
        "<b>"(date -ud @(math "$CMD_DURATION" / 1000) +%T)"</b>"

      if set -q TMUX
        set tty "tmux:"(tmux display-message -p '#I:#P')
      else
        set tty (tty)
      end

      notify-send \
        --urgency=low \
        --icon="$icon_name" \
        --expire-time="$notification_timeout" \
        "Fish ($tty)" \
        "Command $command_body finished with return status $command_status (elapsed $command_duration)"
    end
  end
''

# vim: ft=fish:
