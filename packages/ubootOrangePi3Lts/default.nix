{ writeText, buildUBoot
, armTrustedFirmwareAllwinnerH6
}: buildUBoot {
  defconfig = "orangepi_3_lts_defconfig";
  extraPatches = [ ./add-orangepi-3-lts-dtb.patch ];
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareAllwinnerH6}/bl31.bin";
  filesToInstall = ["u-boot-sunxi-with-spl.bin"];
}
