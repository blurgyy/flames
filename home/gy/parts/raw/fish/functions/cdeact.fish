if not set -l _conda_bin (__find_conda_bin)
  return 1
end
$_conda_bin shell.fish deactivate $argv | source
if test "$pipestatus[1]" -eq 0
  set -e CONDA_EXE CONDA_SHLVL CONDA_PYTHON_EXE
  set -gx PIP_REQUIRE_VIRTUALENV 1
end
