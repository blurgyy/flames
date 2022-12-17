if not set -q CONDA_DEFAULT_ENV
  return 0
end
set -lx tide_conda_icon 🅒
set -lx tide_conda_color green
set -lx tide_conda_bg_color normal
_tide_print_item conda (echo -n $tide_conda_icon' '$CONDA_DEFAULT_ENV)
