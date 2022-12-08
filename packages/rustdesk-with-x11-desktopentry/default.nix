{ stdenv, rustdesk, makeDesktopItem }: let
  rustdesk-fixed = rustdesk.overrideAttrs (o: {
    postPatch = o.postPatch or "" + ''
      sed -Ee '/let _ =/s/(.*)/#\[allow\(let_underscore_lock\)\]\n\1/' -i libs/hbb_common/src/config.rs
    '';
  });
in stdenv.mkDerivation rec {
  pname = "rustdesk-with-x11-desktopentry";
  inherit (rustdesk) version meta;
  desktopItems = [(makeDesktopItem {
    name = "rustdesk-x11";
    exec = ''env -u WAYLAND_DISPLAY ${rustdesk-fixed}/bin/${rustdesk.meta.mainProgram}'';
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
