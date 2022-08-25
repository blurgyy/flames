{ ... }: {
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "cube";
  networking.domain = "blurgy.xyz";
  time.timeZone = "Asia/Hong_Kong";

  system.stateVersion = "22.11";
}
