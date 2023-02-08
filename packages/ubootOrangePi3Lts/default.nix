{ writeText, buildUBoot
, armTrustedFirmwareAllwinnerH6
}: buildUBoot {
  defconfig = "orangepi_3_lts_defconfig";
  extraPatches = [(writeText "add-config-for-orangepi-3-lts" ''
    diff --git a/configs/orangepi_3_lts_defconfig b/configs/orangepi_3_lts_defconfig
    new file mode 100644
    index 00000000..f119c349
    --- /dev/null
    +++ b/configs/orangepi_3_lts_defconfig
    @@ -0,0 +1,18 @@
    +CONFIG_ARM=y
    +CONFIG_ARCH_SUNXI=y
    +CONFIG_MACH_SUN50I_H6=y
    +CONFIG_SUNXI_DRAM_H6_LPDDR3=y
    +CONFIG_SUNXI_DRAM_DDR3=n
    +CONFIG_DRAM_ODT_EN=y
    +CONFIG_MMC0_CD_PIN="PF6"
    +CONFIG_MMC_SUNXI_SLOT_EXTRA=2
    +CONFIG_HDMI_DDC_EN="PH2"
    +# CONFIG_PSCI_RESET is not set
    +CONFIG_DEFAULT_DEVICE_TREE="sun50i-h6-orangepi-3-lts"
    +# CONFIG_SYS_MALLOC_CLEAR_ON_INIT is not set
    +CONFIG_SPL=y
    +# CONFIG_CMD_FLASH is not set
    +# CONFIG_CMD_FPGA is not set
    +# CONFIG_SPL_DOS_PARTITION is not set
    +# CONFIG_SPL_ISO_PARTITION is not set
    +# CONFIG_SPL_EFI_PARTITION is not set
  '')];
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareAllwinnerH6}/bl31.bin";
  filesToInstall = ["u-boot-sunxi-with-spl.bin"];
}
