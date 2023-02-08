{ writeText, buildUBoot, fetchFromGitHub
, armTrustedFirmwareAllwinnerH6
}: let
  opi-u-boot-src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "u-boot-orangepi";
    rev = "c97dbbcad55f5a1e40c28b1a9874b2e0b9f163c9";
    hash = "sha256-1uTTXZDaxTP4Hm+GlR3c2zJBSLZaCd5gXZDOBOUnRtQ=";
  };
in buildUBoot {
  src = opi-u-boot-src;
  version = "unstable";  # NOTE: needed when setting src explicitly
  defconfig = "orangepi_3_lts_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareAllwinnerH6}/bl31.bin";
  filesToInstall = ["u-boot-sunxi-with-spl.bin"];
}
