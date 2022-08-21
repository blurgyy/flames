set -l revision HEAD
if test (count $argv) -gt 0
  set revision $arg[1]
end
if git status >/dev/null 2>&1
  if set -l cmtcnt (git rev-list --count "$revision" 2>/dev/null)
    printf "Revision <"
    set_color -ou bryellow
    printf "$revision"
    set_color normal
    printf ">:"
    set_color brgreen
    printf " $cmtcnt "
    set_color normal
    if test $cmtcnt -eq 1
      echo "commit"
    else
      echo "commits"
    end
  else
    echo (set_color brred)Unrecognized git revision(set_color normal)
  end
else
  echo (set_color brred)"Not under a git repository"(set_color normal)
end
