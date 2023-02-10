{ writeText, buildUBoot, fetchFromGitHub
, armTrustedFirmwareAllwinnerH6
}: (buildUBoot rec {
  # NOTE: upstream uses o-boot v2020.04
  # REF: <https://github.com/orangepi-xunlong/u-boot-orangepi/branches>
  version = "2020.04";
  src = fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    rev = "v${version}";
    hash = "sha256-4FuqNROiSTVNavfmcJ+K67pJhCsAlPLYn2/aXjvV5Eo=";
  };
  defconfig = "orangepi_3_lts_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  BL31 = "${armTrustedFirmwareAllwinnerH6}/bl31.bin";
  filesToInstall = ["u-boot-sunxi-with-spl.bin"];
}).override {
  patches = [ ./add-support-for-orangepi-3-lts.patch ];
}
