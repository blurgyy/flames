{ myName, ... }: {
  imports = [] ++ (if (myName != "root") then [
    ./radicle.nix
  ] else []);
}
