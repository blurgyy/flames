function __conda_envset
  set -e PIP_REQUIRE_VIRTUALENV
  if set -q fish_history
    set -gx old_fish_history "$fish_history"
  end
  if set -q LD_LIBRARY_PATH
    set -gx old_LD_LIBRARY_PATH "$LD_LIBRARY_PATH"
  end
  set -l invalid_chars '/|-|\.|@|#|%'
  set -gx fish_history "condaenv_$(string replace --all --regex -- "$invalid_chars" _ "$argv[1]")"
  set -gx LD_LIBRARY_PATH "$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
  # remove from global function space
  functions --erase __conda_envset
end

if not set -l _conda_bin (__find_conda_bin)
  return 1
end
if set -q CONDA_PREFIX
  printf "Already in a conda environment " >&2
  printf "("(set_color -ou bryellow)"$CONDA_DEFAULT_ENV"(set_color normal)"), " >&2
  echo "run `"(set_color brgreen)"cdeact"(set_color normal)"` first" >&2
  return 2
end
if test (count $argv) -gt 0
  $_conda_bin shell.fish activate "$argv[1]" | source
  if test "$pipestatus[1]" -eq 0
    __conda_envset "$argv[1]"
  end
else if set -l cur (basename (tt gr) 2>/dev/null)
  $_conda_bin shell.fish activate "$cur" | source
  if test "$pipestatus[1]" -eq 0
    __conda_envset "$cur"
  end
else
  echo "Usage: "(status current-command)" <env-name>" >&2
  return 3
end
