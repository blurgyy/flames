{ headless }: [
  ./configuration.nix
  ./hardware.nix
  ./network
  ./secret
] ++ (if (!headless) then[
  ./non-headless-extras.nix
] else [])
