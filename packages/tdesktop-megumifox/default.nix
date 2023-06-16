{ source, tdesktop
, qt6
}:

tdesktop.overrideAttrs (o: {
  pname = "tdesktop-megumifox";
  inherit (source) version src;
  patchFlags = "-lNp1";  # See the `prepare()` function in the PKGBUILD from archlinuxcn: <https://github.com/archlinuxcn/repo/tree/master/archlinuxcn/telegram-desktop-megumifox/PKGBUILD>
  cmakeFlags = o.cmakeFlags ++ [
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME=ON"
  ];
  buildInputs = o.buildInputs ++ [
    qt6.qt5compat
  ];
  patches = o.patches or [] ++ [
    # NOTE: These patches are fetched and modified from <https://github.com/archlinuxcn/repo/tree/master/archlinuxcn/telegram-desktop-megumifox>
    ./0001-Use-font-from-environment-variables.patch
    ./0002-add-TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME-back.patch
    ./fix-tgcalls-cstdint.patch
  ];
})
