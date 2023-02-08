{ armTrustedFirmwareAllwinner, buildUBoot }: buildUBoot {
  defconfig = "orangepi_3_defconfig";
  extraMeta.platforms = ["aarch64_linux"];
  BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
  filesToInstall = ["u-boot-sunxi-with-spl.bin"];
}
