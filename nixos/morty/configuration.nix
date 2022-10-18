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
    "/elements" = {
      device = "/dev/disk/by-label/wd-elements";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; priority = 0; }
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services = {
    btrfs.autoScrub.fileSystems = [ "/elements" ];
    logind.lidSwitch = "ignore";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # NoteBook FanControl: <https://github.com/nbfc-linux/nbfc-linux>
  environment.etc."nbfc/nbfc.json" = {
    text = ''{"SelectedConfigId": "HP Omen 15-dc00xxxx", "TargetFanSpeeds": [-1]}'';
    mode = "0644";
  };
  systemd = {
    packages = with pkgs; [ plocate ];
    services = {
      nbfc-linux = with pkgs; {
        enable = true;
        description = "NoteBook FanControl service";
        path = [ kmod nbfc-linux ];
        preStart = "${nbfc-linux}/bin/nbfc wait-for-hwmon";
        script = "${nbfc-linux}/bin/nbfc start";
        preStop = "${nbfc-linux}/bin/nbfc stop";
        serviceConfig = {
          Type = "forking";
          PIDFile = /run/nbfc_service.pid;
          TimeoutStopSec = 20;
          Restart = "on-failure";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "22.05";
}
