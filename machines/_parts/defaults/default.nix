{ headless
, isQemuGuest
, withSecrets ? true
}: [
  ./configuration.nix
  ./hardware.nix
  ./network
] ++ (if withSecrets then [
  ./secret
] else []) ++ (if (!headless) then [
  ./non-headless-extras.nix
] else []) ++ (if isQemuGuest then [
  ({ modulesPath, ... }: { imports = [ (modulesPath + "/profiles/qemu-guest.nix") ]; })
] else [
  ({ modulesPath, ... }: { imports = [ (modulesPath + "/installer/scan/not-detected.nix") ]; })
])
