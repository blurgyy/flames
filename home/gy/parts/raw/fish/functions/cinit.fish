if not set -l _conda_root (__find_conda_root)
  return 1
end
$_conda_root/bin/conda shell.fish hook | source
