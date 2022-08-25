{ ... }: {
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "peterpan";
  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "22.11";
}
