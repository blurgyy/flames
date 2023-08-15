{ generated, source, tdesktop
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
  postPatch = ''
    patch --verbose -b -d Telegram/lib_ui/ -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-megumifox/0001-Use-font-from-environment-variables.patch
    patch --verbose -b -lNp1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-megumifox/0002-add-TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME-back.patch
  '';
  meta.platforms = [ "x86_64-linux" ];  # save build time on the aarch64 builder
})
