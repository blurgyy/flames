{ headless, withSecrets ? true }: [
  ./configuration.nix
  ./hardware.nix
  ./network
] ++ (if withSecrets then [
  ./secret
] else []) ++ (if (!headless) then [
  ./non-headless-extras.nix
] else [])
