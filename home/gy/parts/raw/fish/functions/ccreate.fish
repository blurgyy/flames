if not set -l _conda_bin (__find_conda_bin)
  return 1
end
argparse -n ccreate y n/name= no-default-packages -- $argv
if not set -q _flag_name
  if set -l cur (basename (tt gr) 2>/dev/null)
    if clist 2>/dev/null | grep -q "^$cur\$" 2>/dev/null
      echo "Not creating existing env '$cur'" >&2
      return 2
    else
      # Omit `env` here (use `conda` instead of `conda env`).
      # Reference:
      # https://github.com/conda/conda/issues/3859#issuecomment-260001212
      $_conda_bin create -n "$cur" $_flag_no_default_packages $_flag_y $argv
    end
  end
else if string length -q $_flag_name
  $_conda_bin create -n $_flag_name $_flag_no_default_packages $_flag_y $argv
else
  echo "Usage: "(status current-command)" [-n <env-name>]" \
    "[--no-default-packages] [-y]" >&2
end
