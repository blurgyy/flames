{ generated, source, tdesktop
, qt6
}:

tdesktop.overrideAttrs (o: {
  pname = "tdesktop-lily";
  inherit (source) version src;
  cmakeFlags = o.cmakeFlags ++ [
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME=ON"
  ];
  buildInputs = o.buildInputs ++ [
    qt6.qt5compat
  ];
  # See the `prepare()` function in the PKGBUILD from archlinuxcn: <https://github.com/archlinuxcn/repo/blob/1df7cb1204df5c548b8250f4a67af28f511c5897/archlinuxcn/telegram-desktop-lily/PKGBUILD#L44>
  postPatch = ''
    patch -b -l -d Telegram/lib_ui -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/no-embolded-font.patch
    patch -b -l -d Telegram/lib_ui -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/dont-adjust-fontsize.patch
    patch -b -l -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/0001-add-TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME-back.patch
    patch -b -l -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/0002-make-blockquote-markup-less-distractive.patch
    patch -b -l -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/0003-Drop-usage-of-Qt-6.5-colorScheme-API-on-Linux.patch
    patch -b -l -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/0004-make-animated-avatar-follow-power-settings.patch
    patch -b -l -Np1 -i ${generated.alcn-repo.src}/archlinuxcn/telegram-desktop-lily/warn-before-delete-all-2.patch
  '';
  meta = {
    platforms = [ "x86_64-linux" ];  # save build time on the aarch64 builder
    mainProgram = o.meta.mainProgram or "telegram-desktop";
  };
})
