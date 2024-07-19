{ pkgs, ... }: {
  time.timeZone = "Asia/Shanghai";

  boot.loader.systemd-boot.enable = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "discard=async" "subvol=root" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "discard=async" "subvol=nix" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-esp";
      fsType = "vfat";
    };
    "/atom" = {
      device = "/dev/disk/by-label/atom";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "ssd" "discard=async" "nofail" ];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; priority = 0; }
  ];

  console.keyMap = "${pkgs.hp-omen-use-sun_unix-layout-keymaps}/share/kbd/keymap.vconsole";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "22.05";
}
