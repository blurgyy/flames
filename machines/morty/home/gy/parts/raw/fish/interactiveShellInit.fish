## starship is managed by nix
#starship init fish | source

function fish_greeting
  # Write motd here ..
end

function exec_zellij
  set session_name (whoami)@(hostnamectl hostname)
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
    new-window -n $wname \; \
    select-window -t $wname
end

function bootstrap
  fish_config theme choose catppuccin

  # Use vi-like keybindings
  fish_vi_key_bindings

  # Install `libnotify` to enable this
  if command -v notify-send >/dev/null
    and not set -q SSH_CONNECTION
    and not test (id -u) -eq 0
    and not string match --quiet --entire --regex '^/dev/tty\d*$' (tty)
    __notify_when_long_running_process_finishes
  end


  # Volatile environment variables
  set -gx GPG_TTY (tty)
end

if string match -q "/dev/tty*" (tty)  # Do not autostart tmux in tty
  echo "Not autostarting terminal multiplexer in a tty" >&2
else if test 0 -eq (id -u)  # Do not autostart tmux as root
  echo "Not autostarting terminal multiplexer as root" >&2
else if set -q ZELLIJ # Do not nest zellij session
else if set -q TMUX # Do not nest tmux session
else if type -q zellij  # Try zellij first
  if zellij setup --check >/dev/null 2>/dev/null
    exec_zellij
  else
    exec_tmux
  end
else if type -q tmux  # If tmux is installed
  exec_tmux
end

bootstrap
