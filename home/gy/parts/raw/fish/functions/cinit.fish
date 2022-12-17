if not set -l _conda_bin (__find_conda_bin)
  return 1
end
$_conda_bin shell.fish hook | source
