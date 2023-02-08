{ pkgs, lib, modulesPath, config, ... }: {
  time.timeZone = "Asia/Shanghai";

  # needed for building sd-card image, REF: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot = let
    supportedFilesystems = lib.mkForce [  # Remove zfs from supportedFilesystems
      "btrfs" "cifs" "ext4" "f2fs" "ntfs" "reiserfs" "vfat" "xfs"
    ];
  in {
    kernelPackages = pkgs.linuxPackages_latest;
    inherit supportedFilesystems;
    initrd = {
      inherit supportedFilesystems;
      availableKernelModules = [ "usbhid" "usb_storage" ];
    };
  };

  sdImage = {  # REF: <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616#Periphery>
    postBuildCommands = ''
      dd if=${pkgs.ubootOrangePi3Lts}/u-boot-sunxi-with-spl.bin of=$img bs=1k seek=8 conv=notrunc
    '';
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree = {
    enable = true;
    name = "allwinner/sun50i-h6-orangepi-3-lts.dtb";
    kernelPackage = config.boot.kernelPackages.kernel.overrideAttrs (o: {
      patches = o.patches or [] ++ [(pkgs.writeText "add-opi3lts-dts.patch" ''
        diff --git a/arch/arm64/boot/dts/allwinner/Makefile b/arch/arm64/boot/dts/allwinner/Makefile
        index 6a96494a2..ace8159a6 100644
        --- a/arch/arm64/boot/dts/allwinner/Makefile
        +++ b/arch/arm64/boot/dts/allwinner/Makefile
        @@ -32,6 +32,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-zero-plus.dtb
         dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-zero-plus2.dtb
         dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-beelink-gs1.dtb
         dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-3.dtb
        +dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-3-lts.dtb
         dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-lite2.dtb
         dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-one-plus.dtb
         dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-pine-h64.dtb
        diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3-lts.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3-lts.dts
        new file mode 100644
        index 000000000..422a752a5
        --- /dev/null
        +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3-lts.dts
        @@ -0,0 +1,180 @@
        +// SPDX-License-Identifier: (GPL-2.0+ or MIT)
        +/*
        + * Copyright (C) 2018 Amarula Solutions
        + * Author: Jagan Teki <jagan@amarulasolutions.com>
        + */
        +
        +/dts-v1/;
        +
        +#include "sun50i-h6.dtsi"
        +
        +#include <dt-bindings/gpio/gpio.h>
        +
        +/ {
        +	model = "OrangePi 3 LTS";
        +	compatible = "xunlong,orangepi-3-lts", "allwinner,sun50i-h6";
        +
        +	aliases {
        +		serial0 = &uart0;
        +		ethernet0 = &emac;
        +	};
        +
        +	chosen {
        +		stdout-path = "serial0:115200n8";
        +	};
        +};
        +
        +&emac {
        +	pinctrl-names = "default";
        +	pinctrl-0 = <&ext_rgmii_pins>;
        +	phy-mode = "rgmii";
        +	phy-handle = <&ext_rgmii_phy>;
        +	phy-supply = <&reg_aldo2>;
        +	allwinner,rx-delay-ps = <200>;
        +	allwinner,tx-delay-ps = <200>;
        +	status = "okay";
        +};
        +
        +&mdio {
        +	ext_rgmii_phy: ethernet-phy@1 {
        +		compatible = "ethernet-phy-ieee802.3-c22";
        +		reg = <1>;
        +	};
        +};
        +
        +&mmc0 {
        +	pinctrl-names = "default";
        +	pinctrl-0 = <&mmc0_pins>;
        +	vmmc-supply = <&reg_cldo1>;
        +	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>;
        +	bus-width = <4>;
        +	status = "okay";
        +};
        +
        +&mmc2 {
        +	pinctrl-names = "default";
        +	pinctrl-0 = <&mmc2_pins>;
        +	vmmc-supply = <&reg_cldo1>;
        +	non-removable;
        +	cap-mmc-hw-reset;
        +	bus-width = <8>;
        +	status = "okay";
        +};
        +
        +&r_i2c {
        +	status = "okay";
        +
        +	axp805: pmic@36 {
        +		compatible = "x-powers,axp805", "x-powers,axp806";
        +		reg = <0x36>;
        +		interrupt-parent = <&r_intc>;
        +		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
        +		interrupt-controller;
        +		#interrupt-cells = <1>;
        +		x-powers,self-working-mode;
        +
        +		regulators {
        +			reg_aldo1: aldo1 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <3300000>;
        +				regulator-max-microvolt = <3300000>;
        +				regulator-name = "vcc-pl";
        +			};
        +
        +			reg_aldo2: aldo2 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <3300000>;
        +				regulator-max-microvolt = <3300000>;
        +				regulator-name = "vcc-ac200";
        +			};
        +
        +			reg_aldo3: aldo3 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <3300000>;
        +				regulator-max-microvolt = <3300000>;
        +				regulator-name = "vcc25-dram";
        +			};
        +
        +			reg_bldo1: bldo1 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <1800000>;
        +				regulator-max-microvolt = <1800000>;
        +				regulator-name = "vcc-bias-pll";
        +			};
        +
        +			reg_bldo2: bldo2 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <1800000>;
        +				regulator-max-microvolt = <1800000>;
        +				regulator-name = "vcc-efuse-pcie-hdmi-io";
        +			};
        +
        +			reg_bldo3: bldo3 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <1800000>;
        +				regulator-max-microvolt = <1800000>;
        +				regulator-name = "vcc-dcxoio";
        +			};
        +
        +			bldo4 {
        +				/* unused */
        +			};
        +
        +			reg_cldo1: cldo1 {
        +				regulator-always-on;
        +				regulator-min-microvolt = <3300000>;
        +				regulator-max-microvolt = <3300000>;
        +				regulator-name = "vcc-3v3";
        +			};
        +
        +			reg_cldo2: cldo2 {
        +				regulator-min-microvolt = <3300000>;
        +				regulator-max-microvolt = <3300000>;
        +				regulator-name = "vcc-wifi-1";
        +			};
        +
        +			reg_cldo3: cldo3 {
        +				regulator-min-microvolt = <3300000>;
        +				regulator-max-microvolt = <3300000>;
        +				regulator-name = "vcc-wifi-2";
        +			};
        +
        +			reg_dcdca: dcdca {
        +				regulator-always-on;
        +				regulator-min-microvolt = <810000>;
        +				regulator-max-microvolt = <1080000>;
        +				regulator-name = "vdd-cpu";
        +			};
        +
        +			reg_dcdcc: dcdcc {
        +				regulator-min-microvolt = <810000>;
        +				regulator-max-microvolt = <1080000>;
        +				regulator-name = "vdd-gpu";
        +			};
        +
        +			reg_dcdcd: dcdcd {
        +				regulator-always-on;
        +				regulator-min-microvolt = <960000>;
        +				regulator-max-microvolt = <960000>;
        +				regulator-name = "vdd-sys";
        +			};
        +
        +			reg_dcdce: dcdce {
        +				regulator-always-on;
        +				regulator-min-microvolt = <1200000>;
        +				regulator-max-microvolt = <1200000>;
        +				regulator-name = "vcc-dram";
        +			};
        +
        +			sw {
        +				/* unused */
        +			};
        +		};
        +	};
        +};
        +
        +&uart0 {
        +	pinctrl-names = "default";
        +	pinctrl-0 = <&uart0_ph_pins>;
        +	status = "okay";
        +};
      '')];
    });
  };

  # Free up to 1GiB whenever there is less than 100MiB left.
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  environment.systemPackages = with pkgs; [
    transmission
  ];

  documentation.nixos.enable = false;

  system.stateVersion = "22.11";
}
