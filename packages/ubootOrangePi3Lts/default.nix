{ writeText, fetchurl, fetchFromGitHub, lib, stdenv
, ncurses # tools/kwboot
, bc
, bison
, dtc
, flex
, openssl
, buildPackages
, swig
, which
, libuuid
, gnutls
, armTrustedFirmwareAllwinnerH6
}: let
  defaultVersion = "2022.10";
  defaultSrc = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${defaultVersion}.tar.bz2";
    hash = "sha256-ULRIKlBbwoG6hHDDmaPCbhReKbI1ALw1xQ3r1/pGvfg=";
  };
  buildUBoot = lib.makeOverridable ({
    version ? null
  , src ? null
  , filesToInstall
  , installDir ? "$out"
  , defconfig
  , extraConfig ? ""
  , extraPatches ? []
  , extraMakeFlags ? []
  , extraMeta ? {}
  , ... } @ args: stdenv.mkDerivation ({
    pname = "uboot-${defconfig}";

    version = if src == null then defaultVersion else version;

    src = if src == null then defaultSrc else src;

    patches = [
      ./0001-configs-rpi-allow-for-bigger-kernels.patch

      # NOTE: removed to allow patching
      # # Make U-Boot forward some important settings from the firmware-provided FDT. Fixes booting on BCM2711C0 boards.
      # # See also: https://github.com/NixOS/nixpkgs/issues/135828
      # # Source: https://patchwork.ozlabs.org/project/uboot/patch/20210822143656.289891-1-sjoerd@collabora.com/
      # ./0001-rpi-Copy-properties-from-firmware-dtb-to-the-loaded-.patch
    ] ++ extraPatches;

    postPatch = ''
      patchShebangs tools
      patchShebangs arch/arm/mach-rockchip
    '';

    nativeBuildInputs = [
      ncurses # tools/kwboot
      bc
      bison
      dtc
      flex
      openssl
      (buildPackages.python3.withPackages (p: [
        p.libfdt
        p.setuptools # for pkg_resources
      ]))
      swig
      which # for scripts/dtc-version.sh
    ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];

    buildInputs = [
      ncurses # tools/kwboot
      libuuid # tools/mkeficapsule
      gnutls # tools/mkeficapsule
    ];

    hardeningDisable = [ "all" ];

    enableParallelBuilding = true;

    makeFlags = [
      "DTC=dtc"
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ] ++ extraMakeFlags;

    passAsFile = [ "extraConfig" ];

    # Workaround '-idirafter' ordering bug in staging-next:
    #   https://github.com/NixOS/nixpkgs/pull/210004
    # where libc '-idirafter' gets added after user's idirafter and
    # breaks.
    # TODO(trofi): remove it in staging once fixed in cc-wrapper.
    preConfigure = ''
      export NIX_CFLAGS_COMPILE_BEFORE_${lib.replaceStrings ["-" "."] ["_" "_"] buildPackages.stdenv.hostPlatform.config}=$(< ${buildPackages.stdenv.cc}/nix-support/libc-cflags)
      export NIX_CFLAGS_COMPILE_BEFORE_${lib.replaceStrings ["-" "."] ["_" "_"]               stdenv.hostPlatform.config}=$(<               ${stdenv.cc}/nix-support/libc-cflags)
    '';

    configurePhase = ''
      runHook preConfigure

      make ${defconfig}

      cat $extraConfigPath >> .config

      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

      mkdir -p "$out/nix-support"
      ${lib.concatMapStrings (file: ''
        echo "file binary-dist ${installDir}/${builtins.baseNameOf file}" >> "$out/nix-support/hydra-build-products"
      '') filesToInstall}

      runHook postInstall
    '';

    dontStrip = true;

    meta = with lib; {
      homepage = "https://www.denx.de/wiki/U-Boot/";
      description = "Boot loader for embedded systems";
      license = licenses.gpl2;
      maintainers = with maintainers; [ bartsch dezgeg samueldr lopsided98 ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" ]));
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
