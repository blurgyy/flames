{ pkgs }:
with builtins; {
  enable = true;
  functions = {
    __notify_when_long_running_process_finishes = {
      body = readFile ../raw/fish/functions/__notify_when_long_running_process_finishes.fish;
      onEvent = "fish_postexec";
    };
    fish_title.body = readFile ../raw/fish/functions/fish_title.fish;
  };
  interactiveShellInit = readFile ../raw/fish/interactiveShellInit.fish;
  shellAbbrs = import ./abbrs.nix;
  shellAliases = with pkgs; {
    meshlab = "QT_QPA_PLATFORM=xcb ${sdwrap}/bin/sdwrap ${meshlab}/bin/meshlab";
    #dingtalk = "${sdwrap}/bin/sdwrap ${nixos-cn.dingtalk}/bin/dingtalk";
  };
}
