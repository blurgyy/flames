{ config, pkgs }: ''
## starship is managed by nix
#starship init fish | source

function fish_greeting
  # Write motd here ..
end

function exec_zellij
  set session_name (whoami)@(hostnamectl hostname; or hostname; or cat /etc/hostname)
  exec zellij attach --create "$session_name"
end

function exec_tmux
  set tsess "main"
  set default_wname "default"
  set wname (date '+%b-%d,%H-%M-%S')

  if set -q SSH_CONNECTION  # If inside an SSH session
    set wname "$wname [ssh]"
    set default_wname "$default_wname [ssh]"
  end

  if not tmux has-session -t $tsess 2>/dev/null
    # If session '$tsess' does not exist, create first
    tmux start-server
    tmux select-window -t $tsess:0 \; \
      rename-window $default_wname
  end

  exec tmux new-session -t $tsess \; \
    new-window
end

function bootstrap
  fish_config theme choose 'Catppuccin ${if config.ricing.textual.theme == "light" then "Latte" else "Mocha"}'

  # Use vi-like keybindings
  fish_vi_key_bindings

  # Install `libnotify` to enable this
  if command -v notify-send >/dev/null
    and not set -q SSH_CONNECTION
    and not test (id -u) -eq 0
    and not string match --quiet --entire --regex '^/dev/tty\d*$' (tty)
    __notify_when_long_running_process_finishes
  end

  # abbr
  function __last_history_item
      echo $history[1]
  end
  abbr -a !! --position anywhere --function __last_history_item

  # Set fish_history if inside nix env
  if set -q IN_NIX_SHELL
    set -l invalid_chars '/|-|\.|@|#|%'
    set -l git_root "$(${pkgs.tinytools}/bin/tt gr)"
    if set -q name
      set -g fish_history \
        "nixshell$(string replace --all --regex -- "$invalid_chars" _ "$git_root")_$IN_NIX_SHELL""_$(string replace --all --regex -- "$invalid_chars" _ "$name")"
    else
      set -g fish_history \
        "nixshell$(string replace --all --regex -- "$invalid_chars" _ "$git_root")_$IN_NIX_SHELL"
    end
  end

  # Volatile environment variables
  #set -gx GPG_TTY (tty)  # already set in .zshrc if `services.gpg-agent` is enabled
end

## 03: fetch
#if string match --quiet --entire --regex '^/dev/tty[0-9]$' (tty)
#  if type -q macchina
#    clear && macchina
#  end
#end

# 05: start-gui
if string match --quiet --entire --regex '^/dev/tty2$' (tty)
  if lsmod | grep -q nvidia
    # Do not disable hardware cursors when using iGPU, because it leads to cursors fail to hide
    # when taking screenshots, it's a wlroots bug:
    #   - <https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/2301>
    #   - <https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1363>
    # This setting was originally added since hardware cursor is not rendering on an NVIDIA dGPU
    # with 495+ driver which added GBM support but still quite buggy.
    ## Fix cursor rendering with Nvidia proprietary driver
    #set -x WLR_NO_HARDWARE_CURSORS 1

    # According to this GitHub issue comment:
    # <https://github.com/swaywm/sway/issues/5642#issuecomment-680771073>
    # Specifying `WLR_DRM_DEVICES=$iGPU:$dGPU` will let the $iGPU do the rendering and use
    # llvmpipe to copy the buffer to the dGPU.  To make sure /dev/dri/card0 is the iGPU, specify
    # i915 in the MODULES array in /etc/mkinitcpio.conf before other driver modules should work (I
    # think).
    #
    # Yet with the NVIDIA proprietary driver, this does not work, after setting this, only the
    # first GPU's connected monitor is displaying a buffer, the other is frozen.
    #
    # Use `lspci` and `ls -l /dev/dri/by-path/` to determine how the cards are ordered (e.g. if
    # card0 is iGPU or dGPU).
    #set -x WLR_DRM_DEVICES "/dev/dri/card0:/dev/dri/card1"

    exec sway --unsupported-gpu >>"$XDG_RUNTIME_DIR/sway.log" 2>&1
  else
    exec sway >>"$XDG_RUNTIME_DIR/sway.log" 2>&1
  end
else if string match --quiet --entire --regex '^/dev/tty6$' (tty)
  exec Hyprland >>"$XDG_RUNTIME_DIR/hyprland.log" 2>&1
end

# 50: multiplexer
if string match -q "/dev/tty*" (tty)  # Do not autostart tmux in tty
  echo "Not autostarting terminal multiplexer in a tty" >&2
else if test 0 -eq (id -u)  # Do not autostart tmux as root
  echo "Not autostarting terminal multiplexer as root" >&2
else if set -q ZELLIJ  # Do not nest zellij session
else if set -q TMUX  # Do not nest tmux session
else if set -q noexecmultiplexer  # explicitly not executing
else if type -q tmux
  exec_tmux
else if type -q zellij
  if zellij setup --check >/dev/null 2>/dev/null
    exec_zellij
  else if type -q tmux
    exec_tmux
  end
end

bootstrap
''
