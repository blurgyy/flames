if not test -d /sbin
  return 0
end
set -lx tide_fhs_color purple
set -lx tide_fhs_bg_color normal
_tide_print_item fhs (echo -n [fhs])
