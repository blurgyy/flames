{ writeScriptBin }: writeScriptBin "nix-daemon" (builtins.readFile ./nix-daemon)
