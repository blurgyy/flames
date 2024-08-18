{ self
, inputs
, system
, headless
, isQemuGuest
, withBinfmtEmulation
, withSecrets ? true
}: let
  includeIf = inputs.nixpkgs.lib.optionalAttrs;
in [
  ./configuration.nix
  ./hardware.nix
  ./network
  ./haproxy.nix
  ./services

  inputs.nix-index-db.nixosModules.nix-index
  self.nixosModules.default
  {
    nixpkgs.overlays = [
      self.overlays.default
    ] ++ self.sharedOverlays;
  }

  (includeIf withSecrets ./secret)
  (includeIf withSecrets inputs.sops-nix.nixosModules.sops)

  (includeIf (!headless) ./headful.nix)

  ({ config, ... }: {
    environment.presets = let
      inherit (config.networking) hostName;
    in with builtins; {
      development = elem hostName [
        "morty"
        "winston"
      ];
      entertainment = elem hostName [
        "morty"
        "rpi"
        "opi"
      ];
      recreation = elem hostName [
        "morty"
        "opi"
        "rpi"
        "winston"
      ];
    };
  })

  (includeIf isQemuGuest ({ lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
    documentation.nixos.enable = lib.mkDefault false;
  }))
  (includeIf (!isQemuGuest) ({ config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    documentation.nixos.enable = lib.mkDefault true;
    environment.systemPackages = lib.mkIf config.documentation.enable [
      pkgs.man-pages
      pkgs.man-pages-posix
    ];
  }))

  (includeIf withBinfmtEmulation ({ lib, pkgs, ... }: {
    boot.binfmt.emulatedSystems = with lib; let
      getEmulation = system: {
        "aarch64-linux" = [ "x86_64-linux" ];
        "x86_64-linux" = [ "aarch64-linux" "i686-linux" ];
      }.${pkgs.system};
    in mkDefault (getEmulation pkgs.system);
  }))
]
