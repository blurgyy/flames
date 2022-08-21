if not set -l _conda_root (__find_conda_root)
  return 1
end

set -l conda_envs_dir $HOME/.conda/envs
if not test -d $conda_envs_dir
  or test (count (command ls $conda_envs_dir)) -eq 0
  echo "No envs installed under $conda_envs_dir" >&2
  return 2
end

for envname in (command ls $conda_envs_dir)
  if string match --regex "$envname\$" $CONDA_PREFIX >/dev/null
    set_color --bold brwhite
    printf "  " >&2
    set_color --underline
  else
    set_color white
    printf "  " >&2
  end
  echo $envname
  set_color normal
end
