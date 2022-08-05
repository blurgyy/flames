{ tdesktop, fetchpatch, fetchurl }: tdesktop.overrideAttrs (oldAttrs: {
  pname = "tdesktop-megumifox";
  patchFlags = "-lNp1";  # See the `prepare()` function in the PKGBUILD from archlinuxcn: <https://github.com/archlinuxcn/repo/tree/master/archlinuxcn/telegram-desktop-megumifox/PKGBUILD>
  patches = [
  # NOTE: These patches are fetched and modified from <https://github.com/archlinuxcn/repo/tree/master/archlinuxcn/telegram-desktop-megumifox>
    ./0001-Use-QGuiApplication-font-instead-of-opensans.patch
    ./0002-add-TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME-back.patch
  ];
})
