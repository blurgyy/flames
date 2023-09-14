{ lib, rustdesk, makeDesktopItem }: rustdesk.overrideAttrs (o: {
  pname = "rustdesk-with-x11-desktopentry";
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
    sed -Ee 's/Exec=/Exec=env -u WAYLAND_DISPLAY /' \
      -e 's/^Name=(.*)$/Name=\1 (x11)/' \
      $out/share/applications/${(builtins.elemAt o.desktopItems 0).name} \
      > $out/share/applications/x11-${(builtins.elemAt o.desktopItems 0).name}
  '';
  meta.platforms = [ "x86_64-linux" ];
})
