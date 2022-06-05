## Modified from and overrides `/usr/share/fish/functions/fish_title.fish`

# emacs' "term" is basically the only term that can't handle it.
if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
  set cur_command (
    string trim (
      set -q argv[1] && echo $argv[1] || status current-command
    )
  )
  echo "$cur_command" @ (__fish_pwd)
end
