{ armTrustedFirmwareAllwinner, buildUBoot }: buildUBoot {
  defconfig = "orangepi_3_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
  filesToInstall = ["u-boot-sunxi-with-spl.bin"];
}
