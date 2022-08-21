if not set -l _conda_root (__find_conda_root)
  return 1
end
$_conda_root/bin/conda shell.fish deactivate $argv | source
set -e CONDA_EXE CONDA_SHLVL CONDA_PYTHON_EXE _CE_CONDA
