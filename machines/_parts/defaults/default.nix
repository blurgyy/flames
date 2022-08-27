{ headless
, isQemuGuest
, withSecrets ? true
}: [
  ./configuration.nix
  ./hardware.nix
  ./network
  ./haproxy.nix
] ++ (if withSecrets then [
  ./secret
] else []) ++ (if (!headless) then [
  ./non-headless-extras.nix
] else []) ++ (if isQemuGuest then [
  ({ lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  })
] else [
  ({ lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  })
])
