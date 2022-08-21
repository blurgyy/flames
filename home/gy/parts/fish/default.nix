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
    __set_conda_root = {
      description = "Find root of miniconda/anaconda and store to variable `_conda_root`";
      body = readFile ../raw/fish/functions/__set_conda_root.fish;
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
  interactiveShellInit = readFile ../raw/fish/interactiveShellInit.fish;
  shellAbbrs = import ./abbrs.nix { inherit pkgs; };
  shellAliases = with pkgs; {
    meshlab = "QT_QPA_PLATFORM=xcb ${sdwrap}/bin/sdwrap ${meshlab}/bin/meshlab";
    #dingtalk = "${sdwrap}/bin/sdwrap ${nixos-cn.dingtalk}/bin/dingtalk";
  };
}
