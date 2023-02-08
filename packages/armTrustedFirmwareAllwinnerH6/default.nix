{ buildArmTrustedFirmware }: buildArmTrustedFirmware rec {
  # REF: <https://github.com/NixOS/nixpkgs/pull/111700>
  # REF: <https://github.com/u-boot/u-boot/blob/e72a6be4fc071930016903638e1e493ab5d3be8a/board/sunxi/README.sunxi64#L54-L56>
  platform = "sun50i_h6";
  extraMeta.platforms = ["aarch64-linux"];
  filesToInstall = ["build/${platform}/release/bl31.bin"];
}
