{ pkgs }: with pkgs; ''
  set -o vi
  export HISTCONTROL="''${HISTCONTROL:+$HISTCONTROL:}ignoredups"
  source ${fzf}/share/fzf/key-bindings.bash
  source ${fzf}/share/fzf/completion.bash

  export PYTHONDONTWRITEBYTECODE=1
  export PYTHONUNBUFFERED=1

  alias -- -='cd -'
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'

  alias ls='${exa}/bin/exa -F'
  alias l='ls'
  alias s='ls'
  alias sl='ls'
  alias la='ls -a'
  alias a='ls -a'
  alias al='ls -a'
  alias ll='ls -lhg --icons'
  alias tree='ls -T --icons'

  alias g='${git}/bin/git'
  alias ga='g add'
  alias ga.='g add .'
  alias gaa='g add -A'
  alias gb='g branch'
  alias gbs='g branch --set-upstream-to'
  alias gbv='g branch -vv'
  alias gc='g commit -S -sv'
  alias gca='g commit -S -sv --amend'
  alias gcan='g commit -S -sv --amend --no-edit'
  alias gcannosign='g commit -sv --amend --no-edit'
  alias gcanosign='g commit -sv --amend'
  alias gcinit='g commit --allow-empty -m "chore: initalize repository (empty)"';
  alias gcnosign='g commit -sv'
  alias gco='g checkout'
  alias gco.='g checkout .'
  alias gd='g diff'
  alias gdc='g diff --cached'
  alias gf='g fetch'
  alias gl='g log --all --graph --decorate --oneline -8'
  alias gla='g log --all --graph --decorate --format=fuller'
  alias glad='git log --all --graph --decorate --format=fuller --patch --ext-diff'
  alias glap='git log --all --graph --decorate --format=fuller --patch'
  alias gll='g pull'
  alias gln='g log --all --graph --decorate --oneline'
  alias gmt='g mergetool'
  alias gp='g push'
  alias gpf='g push -f'
  alias gs='g status -s'
  alias gsa='g status --show-stash'

  alias gbranch='g branch'
  alias ginit='g init'
  alias gmerge='g merge'
  alias grebase='g rebase'
  alias gremote='g remote'
  alias greset='g reset'
  alias gshow='g show'
  alias gstash='g stash'
  alias gswitch='g switch'
  alias gunstage='g reset HEAD --'

  alias cat='${bat}/bin/bat'
  alias p='python'
  alias fgfg='fg'
  alias ffg='fg'
  alias gfg='fg'

  # Neovim from nixpkgs is statically linked while on Arch it's not.  Don't assume a flake will
  # be run on a NixOS machine.
  # alias vim='${neovim}/bin/nvim'
  alias vi='nvim'
  alias vim='nvim'

  alias rg='${ripgrep}/bin/rg'
  alias fd='${fd}/bin/fd'
  alias procs='${procs}/bin/procs'
  alias htop='${htop}/bin/htop'
  alias lnav='${lnav}/bin/lnav'
  alias rsync='${rsync}/bin/rsync'

  alias xargs='xargs '
  alias parallel='${parallel}/bin/parallel '

  mkdir -p ''${PARALLEL_HOME:-$HOME/.parallel}
  touch ''${PARALLEL_HOME:-$HOME/.parallel}/will-cite
''
