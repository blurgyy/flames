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
  shellAliases = {
    meshlab = "${pkgs.sdwrap}/bin/sdwrap ${pkgs.meshlab}/bin/meshlab";
  };
}
