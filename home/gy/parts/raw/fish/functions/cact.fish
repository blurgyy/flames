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
  if $_conda_bin shell.fish activate $argv[1] | source
    # Allow pip to run inside conda environment
    set -e PIP_REQUIRE_VIRTUALENV
  end
else if set -l cur (basename (tt gr) 2>/dev/null)
  if $_conda_bin shell.fish activate $cur | source
    # Allow pip to run inside conda environment
    set -e PIP_REQUIRE_VIRTUALENV
  end
else
  echo "Usage: "(status current-command)" <env-name>" >&2
  return 3
end
