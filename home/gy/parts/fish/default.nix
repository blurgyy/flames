{ config, lib, pkgs, headless, callWithHelpers }: with builtins; {
  enable = true;
  functions = {
    __notify_when_long_running_process_finishes = lib.mkIf (!headless) {
      body = callWithHelpers ../raw/fish/functions/__notify_when_long_running_process_finishes.fish.nix {};
      onEvent = "fish_postexec";
    };
    _tide_item_conda.body = readFile ../raw/fish/functions/_tide_item_conda.fish;
    _tide_item_fhs.body = readFile ../raw/fish/functions/_tide_item_fhs.fish;
    fish_title.body = readFile ../raw/fish/functions/fish_title.fish;
    gcnt.body = readFile ../raw/fish/functions/gcnt.fish;
    private.body = readFile ../raw/fish/functions/private.fish;
    cg = {
      description = "Goto nearest git root above current directory";
      body = readFile ../raw/fish/functions/cg.fish;
    };
    __find_conda_bin = {
      description = "Find root of miniconda/anaconda and store to variable `_conda_root`";
      body = readFile ../raw/fish/functions/__find_conda_bin.fish;
    };
    cinit = {
      description = "Initialize conda executable";
      body = readFile ../raw/fish/functions/cinit.fish;
    };
    cact = {
      description = "Activate current or specified conda environment";
      body = readFile ../raw/fish/functions/cact.fish;
    };
    cdeact = {
      description = "Deactivate currently activated conda environment";
      body = readFile ../raw/fish/functions/cdeact.fish;
    };
    clist = {
      description = "List all currently installed conda envs";
      body = readFile ../raw/fish/functions/clist.fish;
    };
    ccreate = {
      description = "Create current or specified conda environment";
      body = readFile ../raw/fish/functions/ccreate.fish;
    };
    crm = {
      description = "Remove specified conda environment";
      body = readFile ../raw/fish/functions/crm.fish;
    };
  };
  shellAbbrs = import ./abbrs.nix { inherit pkgs; };
  shellAliases = with pkgs; {
    bhome = "home-manager build -v --flake";
    bosys = "nixos-rebuild boot --use-remote-sudo -L -v --flake";
    busys = "nixos-rebuild build --use-remote-sudo -L -v --flake";
    shome = "home-manager switch -v --flake";
    ssys = "nixos-rebuild switch --use-remote-sudo -L -v --flake";
    meshlab = "QT_QPA_PLATFORM=xcb ${sdwrap}/bin/sdwrap meshlab";
    conda-shell = "conda-shell -c 'fish_history=nix_conda_shell exec fish'";
  };
  plugins = [{
    name = "tide";
    src = pkgs.fish-plugin-tide.src;
  }];
  interactiveShellInit = (
    callWithHelpers ../raw/fish/interactiveShellInit.fish {}
  ) + ''
    source ${pkgs.fish-plugin-tide}/share/fish/functions/_tide_sub_configure.fish
    sed -Ee 's/^/set -U /' \
      ${pkgs.fish-plugin-tide}/share/fish/functions/tide/configure/configs/lean.fish \
      | source
    set -U tide_git_icon 
    set -g tide_right_prompt_items status cmd_duration context node rustc java php ruby go kubectl toolbox terraform aws crystal time
    set -g tide_left_prompt_items nix_shell fhs pwd git conda jobs newline character
    set -g tide_prompt_add_newline_before true
  '';
}
