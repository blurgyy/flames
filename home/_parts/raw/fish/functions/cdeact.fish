function __conda_envunset
  set -e CONDA_EXE CONDA_SHLVL CONDA_PYTHON_EXE
  set -gx PIP_REQUIRE_VIRTUALENV 1
  if set -q old_fish_history
    set fish_history "$old_fish_history"
    set -e old_fish_history
  else
    set -e fish_history
  end
  # remove from global function space
  functions --erase __conda_envunset
end

if not set -l _conda_bin (__find_conda_bin)
  return 1
end
$_conda_bin shell.fish deactivate $argv | source
if test "$pipestatus[1]" -eq 0
  __conda_envunset
end
