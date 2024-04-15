complete -c cact -f
complete -c cact -a "$(command ls "$(dirname (dirname (__find_conda_bin)))/envs")"

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 29 2021, 12:00 [CST]
