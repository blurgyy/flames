{ source, stdenv, lib
, autoPatchelfHook
, gnutar
, fontconfig
, gdk-pixbuf
, glib
, gnome2
, nspr
, nss_latest
, openssl
, pango
, xorg
}: stdenv.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    fontconfig
    gdk-pixbuf
    glib
    gnome2.gtk
    nspr
    nss_latest
    openssl
    pango
    xorg.libX11
    xorg.libXcursor
    xorg.libXrender
  ];

  unpackPhase = "${gnutar}/bin/tar -xf $src";
  installPhase = "install -Dm755 flashplayer $out/bin/flashplayer";

  dontStrip = true;

  meta = {
    homepage = "http://web.archive.org/web/20220331041116/https://www.adobe.com/support/flashplayer/debug_downloads.html";
    description = "Standalone flash player";
    license = with lib.licenses; [ unfree lgpl3 ];
  };
}
