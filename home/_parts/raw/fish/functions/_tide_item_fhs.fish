if not test -d /sbin
  and not test -d /usr/lib/wsl
  and not test -e /.dockerenv
  return 0
end

if test -d /sbin
  if test -d /usr/lib/wsl
    set indicator "fhs(wsl)"
  else if test -f /run/host/container-manager
    set indicator "fhs($(echo (cat /run/host/container-manager)))"
  else if test -f /.dockerenv
    set indicator "fhs(docker)"
  else
    set indicator "fhs"
  end
end

set -lx tide_fhs_color purple
set -lx tide_fhs_bg_color normal
_tide_print_item fhs (echo -n ["$indicator"])
