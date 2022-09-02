{ headless
, isQemuGuest
, withSecrets ? true
, withBinfmtEmulation ? true
}: [
  ./configuration.nix
  ./hardware.nix
  ./network
  ./haproxy.nix
]

++ (if withSecrets then [
  ./secret
] else [])

++ (if (!headless) then [
  ./non-headless-extras.nix
] else [])

++ (if isQemuGuest then [({ lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
  documentation.nixos.enable = lib.mkDefault false;
})] else [({ lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  documentation.nixos.enable = lib.mkDefault true;
})])

++ (if withBinfmtEmulation then [({ lib, pkgs, ... }: {
  boot.binfmt.emulatedSystems = with lib;
    mkDefault (remove pkgs.system [ "aarch64-linux" "x86_64-linux" "i686-linux" ]);
})] else [])
