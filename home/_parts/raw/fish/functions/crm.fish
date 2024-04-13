if not set -l _conda_bin (__find_conda_bin)
  return 1
end
if test (count $argv) -ne 1
  echo "Usage: "(status current-command)" <env-name>" >&2
  return 2
end
if string match --regex '^'$argv[1]'$' $CONDA_DEFAULT_ENV >/dev/null
  printf "Requested to delete currently activated env, "
  echo "run `"(set_color brgreen)"cdeact"(set_color normal)"` first" >&2
  return 3
end
$_conda_bin env remove --name $argv[1]
