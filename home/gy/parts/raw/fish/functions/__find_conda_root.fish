set --local conda_search_path /opt/miniconda /opt/anaconda
set --local --append conda_search_path $HOME/.local/lib/miniconda3
set --local --append conda_search_path $HOME/.local/lib/miniconda
set --local --append conda_search_path $HOME/miniconda3
set --local --append conda_search_path $HOME/miniconda
set --local --append conda_search_path $HOME/.local/lib/anaconda3
set --local --append conda_search_path $HOME/.local/lib/anaconda
set --local --append conda_search_path $HOME/anaconda3
set --local --append conda_search_path $HOME/anaconda
set --local --append conda_search_path $HOME/.conda
for csp in $conda_search_path
  if test -d "$csp"
    echo "$csp"
    return
  end
end
echo >&2 "Could not find a miniconda/anaconda installation under any of ['"(string join \',\' $conda_search_path)"']"
return 1
