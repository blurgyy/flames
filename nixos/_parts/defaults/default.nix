{ self
, inputs
, headless
, isQemuGuest
, withSecrets ? true
, withBinfmtEmulation ? false
}: let
  includeIf = inputs.nixpkgs.lib.optionalAttrs;
in [
  ./configuration.nix
  ./hardware.nix
  ./network
  ./haproxy.nix
  inputs.nixos-cn.nixosModules.nixos-cn
  self.nixosModules.default
  ({ config, pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.supervisedDesktopEntries {
        inputPackages = config.environment.systemPackages;
        mark = "supervised";
      })
    ];
    nixpkgs.overlays = [
      self.overlays.default
      inputs.nixos-cn.overlay
    ];
  })

  (includeIf withSecrets ./secret)
  (includeIf withSecrets inputs.sops-nix.nixosModules.sops)

  (includeIf (!headless) ./headful.nix)
  (includeIf (!headless) ./gaming.nix)

  (includeIf isQemuGuest ({ lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
    documentation.nixos.enable = lib.mkDefault false;
  }))
  (includeIf (!isQemuGuest) ({ lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    documentation.nixos.enable = lib.mkDefault true;
    environment.systemPackages = with pkgs; [ man-pages man-pages-posix ];
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
