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
    for p in ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-megumifox/*.patch; do
      echo applying patch "'$(basename "$p")'" from archlinuxcn repo
      patch -b -d "$src/Telegram/lib_ui/" -Np1 -i "$patch"
    done
  '';
})
