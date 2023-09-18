{ writeShellScriptBin, stdenvNoCC, symlinkJoin }: let
  sdwrap = writeShellScriptBin "sdwrap" (builtins.readFile ./src/sdwrap);
  sdwrap-clean = writeShellScriptBin "sdwrap-clean" (builtins.readFile ./src/sdwrap-clean);
  sdwrap-fish-completions = stdenvNoCC.mkDerivation {
    name = "sdwrap-fish-completions";
    src = ./src/fish-completions;
    buildCommand = ''
      install -Dvm555 -t $out/share/fish/vendor_completions.d $src/*
    '';
  };
in symlinkJoin {
  name = "sdwrap";
  paths = [ sdwrap sdwrap-clean sdwrap-fish-completions ];
}
