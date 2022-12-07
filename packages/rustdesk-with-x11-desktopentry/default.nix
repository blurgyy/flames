{ stdenv, rustdesk, makeDesktopItem }: stdenv.mkDerivation rec {
  pname = "rustdesk-with-x11-desktopentry";
  inherit (rustdesk) version meta;
  desktopItems = [(makeDesktopItem {
    name = "rustdesk-x11";
    exec = ''env -u WAYLAND_DISPLAY ${rustdesk}/bin/${rustdesk.meta.mainProgram}'';
    icon = "rustdesk";
    desktopName = "RustDesk (X11)";
    comment = rustdesk.meta.description;
    genericName = "Remote Desktop";
    categories = ["Network"];
  })];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir $out/share/applications -p
    for desktop in ${toString desktopItems}; do
      cp $desktop/share/applications/* $out/share/applications
    done
  '';
}
