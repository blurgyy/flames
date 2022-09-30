{ self
, inputs
, system
, headless
, isQemuGuest
, withSecrets ? true
, withBinfmtEmulation ? true
}: [
  ./configuration.nix
  ./hardware.nix
  ./network
  ./haproxy.nix
  inputs.nixos-cn.nixosModules.nixos-cn
  self.nixosModules.default
  {
    nixpkgs.overlays = [
      self.overlays.default
      inputs.nixos-cn.overlay
      (final: prev: {
        difftastic = inputs.nixpkgs-difftastic-terminal-width-fix.packages.${system}.difftastic;
      })
    ];
  }
]

++ (if withSecrets then [
  ./secret
  inputs.sops-nix.nixosModules.sops
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
  boot.binfmt.emulatedSystems = with lib; let
    getEmulation = system: {
      "aarch64-linux" = [ "x86_64-linux" ];
      "x86_64-linux" = [ "aarch64-linux" "i686-linux" ];
    }.${system};
  in
    mkDefault (getEmulation pkgs.system);
})] else [])
