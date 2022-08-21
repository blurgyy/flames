if not set -l _conda_root (__find_conda_root)
  return 1
end
if set -q CONDA_PREFIX
  printf "Already in a conda environment " >&2
  printf "("(set_color -ou bryellow)"$CONDA_DEFAULT_ENV"(set_color normal)"), " >&2
  echo "run `"(set_color brgreen)"cdeact"(set_color normal)"` first" >&2
  return 2
end
if test (count $argv) -gt 0
  $_conda_root/bin/conda shell.fish activate $argv[1] | source
else if set -l cur (basename (tt gr) 2>/dev/null)
  $_conda_root/bin/conda shell.fish activate $cur | source
else
  echo "Usage: "(status current-command)" <env-name>" >&2
  return 3
end
