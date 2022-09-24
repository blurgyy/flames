{ pkgs }: with builtins; {
  enable = true;
  functions = {
    __notify_when_long_running_process_finishes = {
      body = readFile ../raw/fish/functions/__notify_when_long_running_process_finishes.fish;
      onEvent = "fish_postexec";
    };
    fish_title.body = readFile ../raw/fish/functions/fish_title.fish;
    gcnt.body = readFile ../raw/fish/functions/gcnt.fish;
    private.body = readFile ../raw/fish/functions/private.fish;
    cg = {
      description = "Goto nearest git root above current directory";
      body = readFile ../raw/fish/functions/cg.fish;
    };
    __find_conda_root = {
      description = "Find root of miniconda/anaconda and store to variable `_conda_root`";
      body = readFile ../raw/fish/functions/__find_conda_root.fish;
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
    #dingtalk = "${sdwrap}/bin/sdwrap ${nixos-cn.dingtalk}/bin/dingtalk";
    bhome = "${pkgs.home-manager}/bin/home-manager build -v --flake";
    bsys = "nixos-rebuild build --use-remote-sudo -v --flake";
    shome = "${pkgs.home-manager}/bin/home-manager switch -v --flake";
    ssys = "nixos-rebuild switch --use-remote-sudo -v --flake";
  };
  plugins = [{
    name = "tide";
    src = pkgs.fish-plugin-tide.src;
  }];
  interactiveShellInit = (
    readFile ../raw/fish/interactiveShellInit.fish
  ) + ''
    source ${pkgs.fish-plugin-tide}/share/fish/vendor_functions.d/_tide_sub_configure.fish
    sed -Ee 's/^/set -U /' \
      ${pkgs.fish-plugin-tide}/share/fish/vendor_functions.d/tide/configure/configs/lean.fish \
      | source
    set -g tide_right_prompt_items $tide_right_prompt_items time
    set -g tide_prompt_add_newline_before false
  '';
}
