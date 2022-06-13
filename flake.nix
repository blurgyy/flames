{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;
    flake-utils.url = github:numtide/flake-utils;
    #nixpkgs.url = github:NixOS/nixpkgs;
    nixos-cn = { url = github:nixos-cn/flakes; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = github:berberman/nvfetcher; inputs.nixpkgs.follows = "nixpkgs"; };
    nbfc-linux = { url = github:nbfc-linux/nbfc-linux; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    acremote = { url = gitlab:highsunz/acremote; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # `self` denotes this flake, otther function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, flake-utils, nixos-cn, ... }: let
    my = import ./packages;
  in flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        self.overlays.default
        nixos-cn.overlay
      ];
    };
  in {
    packages = my.packages pkgs;
    commonShellHook = with pkgs; ''
      set -o vi

      export PYTHONDONTWRITEBYTECODE=1

      alias ls='${exa}/bin/exa -F'
      alias la='ls -a'
      alias ll='ls -lhg --icons'
      alias tree='ls -T --icons'

      alias g='${git}/bin/git'
      alias ga='g add'
      alias gaa='g add -A'
      alias gb='g branch'
      alias gbs='g branch --set-upstream-to'
      alias gbv='g branch -vv'
      alias gc='g commit -S -sv'
      alias gca='g commit -S -sv --amend'
      alias gcan='g commit -S -sv --amend --no-edit'
      alias gcannosign='g commit -sv --amend --no-edit'
      alias gcanosign='g commit -sv --amend'
      alias gcnosign='g commit -sv'
      alias gco='g checkout'
      alias gd='g diff'
      alias gdc='g diff --cached'
      alias gf='g fetch'
      alias gl='g log --all --graph --decorate --oneline -8'
      alias gla='g log --all --graph --decorate --format=fuller'
      alias gll='g pull'
      alias gp='g push'
      alias gpf='g push -f'
      alias gs='g status -s'
      alias gsa='g status --show-stash'
      alias gunstage='g reset HEAD --'

      alias cat='${bat}/bin/bat'

      # Neovim from nixpkgs is statically linked while on Arch it's not.  Don't assume a flake will
      # be run on a NixOS machine.
      # alias vim='${neovim}/bin/nvim'
      alias vim='nvim'

      alias rg='${ripgrep}/bin/rg'
      alias fd='${fd}/bin/fd'
      alias procs='${procs}/bin/procs'
      alias htop='${htop}/bin/htop'
    '';
  }) // {
    overlays.default = my.overlay;
    nixosConfigurations = {
      morty = import ./machines/morty {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
      rpi = import ./machines/rpi {
        system = "aarch64-linux";
        inherit self nixpkgs inputs;
      };
    };
  };
}
