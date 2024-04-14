{ lib, hostName, ... }: {
  imports = [
    ./secrets.nix
    ./services
  ] ++ lib.optional (builtins.pathExists ./per-host/${hostName}.nix) ./per-host/${hostName}.nix;
}
