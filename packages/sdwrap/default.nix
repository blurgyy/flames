{ writeShellScriptBin, symlinkJoin }: let
  sdwrap = writeShellScriptBin "sdwrap" (builtins.readFile ./src/sdwrap);
  sdwrap-clean = writeShellScriptBin "sdwrap-clean" (builtins.readFile ./src/sdwrap-clean);
in symlinkJoin {
  name = "sdwrap";
  paths = [ sdwrap sdwrap-clean ];
}
