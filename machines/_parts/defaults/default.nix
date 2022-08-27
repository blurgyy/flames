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
  ({ pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    boot.kernelPackages = pkgs.linuxPackages;
  })
] else [
  ({ pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
  })
])
