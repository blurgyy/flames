set -lx TMPHOME (mktemp -d)
set -lx HOME "$TMPHOME"
set -lx XDG_CONFIG_HOME "$TMPHOME/.config"
set -lx XDG_CACHE_HOME "$TMPHOME/.cache"
set -lx XDG_DATA_HOME "$TMPHOME/.local/share"
set -lx XDG_STATE_HOME "$TMPHOME/.local/state"
set -lx XDG_RUNTIME_DIR "$TMPHOME/.local/run"
fish \
  --init-command 'trap \'echo " '(set_color -ir red)'WARN'(set_color normal)' $TMPHOME will be nuked in 10 seconds" && sh -c "sleep 10 && rm -rf \$TMPHOME" &\' EXIT' \
  --init-command 'fish_vi_key_bindings || true' \
  --init-command '
    function fish_greeting
      echo " '(set_color -ir brgreen)'INFO'(set_color normal)' The new \$HOME is: '(set_color -iu)$HOME(set_color normal)'"
      echo " '(set_color -ir red)'WARN'(set_color normal)' Everything in the new \$HOME will be nuked when you leave this shell!"
    end
  ' \
  --private
  # --print-rusage-self
