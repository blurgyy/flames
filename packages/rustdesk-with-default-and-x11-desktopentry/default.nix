{ lib, rustdesk-flutter, makeDesktopItem }:

let
  rustdesk = rustdesk-flutter;
in

rustdesk.overrideAttrs (o: {
  pname = "rustdesk-with-default-and-x11-desktopentry";
  desktopItems = o.desktopItems ++ [(makeDesktopItem {
    name = "rustdesk-x11";
    exec = ''env -u WAYLAND_DISPLAY ${rustdesk}/bin/${rustdesk.meta.mainProgram}'';
    icon = "rustdesk";
    desktopName = "RustDesk (X11)";
    comment = rustdesk.meta.description;
    genericName = "Remote Desktop";
    categories = ["Network"];
  })];
  buildCommand = ''
    set -euo pipefail
    ${  # REF: <https://stackoverflow.com/a/68523368/13482274>
      lib.concatStringsSep "\n" (map (outputName: ''
        echo "Copying output ${outputName}"
        set -x
        cp -rs --no-preserve=mode "${rustdesk.${outputName}}" "''$${outputName}"
        set +x
      '')
      (o.outputs or ["out"]))
    }
    set -x
    odir="$out/share/applications"
    mkdir -p "$odir"
    rm -f "$odir"/*.desktop
    cp -f --no-preserve=mode ${./rustdesk.desktop} "$odir/rustdesk.desktop"
    cp -f --no-preserve=mode ${./x11-rustdesk.desktop} "$odir/x11-rustdesk.desktop"
  '';
  meta.platforms = [ "x86_64-linux" ];
})
