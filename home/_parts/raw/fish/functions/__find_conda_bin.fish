# default installation prefix of nixpkgs#conda

if set -q conda_search_path
  # respect existing environment, create a file under `~/.config/fish/conf.d/` to set it
  set --function --append conda_search_path $HOME/.conda
else
  set --function conda_search_path $HOME/.conda
end

set --function --append conda_search_path $HOME/.local/lib/miniconda3
set --function --append conda_search_path $HOME/.local/lib/miniconda
set --function --append conda_search_path $HOME/miniconda3
set --function --append conda_search_path $HOME/miniconda
set --function --append conda_search_path $HOME/.local/lib/anaconda3
set --function --append conda_search_path $HOME/.local/lib/anaconda
set --function --append conda_search_path $HOME/anaconda3
set --function --append conda_search_path $HOME/anaconda
set --function --append conda_search_path /opt/miniconda
set --function --append conda_search_path /opt/anaconda
for csp in $conda_search_path
  if test -x "$csp/condabin/conda"
    echo "$csp/condabin/conda"
    return
  else if test -x "$csp/bin/conda"
    echo "$csp/bin/conda"
    return
  end
end
echo >&2 "Could not find a miniconda/anaconda installation under any of ['"(string join \',\' $conda_search_path)"']"
return 1
