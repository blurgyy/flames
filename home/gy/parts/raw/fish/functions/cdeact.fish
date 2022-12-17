if not set -l _conda_bin (__find_conda_bin)
  return 1
end
if $_conda_bin shell.fish deactivate $argv | source
  set -e CONDA_EXE CONDA_SHLVL CONDA_PYTHON_EXE _CE_CONDA
  set -x PIP_REQUIRE_VIRTUALENV 1
end
