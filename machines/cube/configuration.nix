{ ... }: {
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "cube";
  time.timeZone = "Asia/Hong_Kong";

  system.stateVersion = "22.11";
}
