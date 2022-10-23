{ rustdesk, makeDesktopItem }: rustdesk.overrideAttrs (o: {
  desktopItems = o.desktopItems ++ [ (makeDesktopItem {
    name = "rustdesk-x11";
    exec = ''env -u WAYLAND_DISPLAY ${o.meta.mainProgram}'';
    icon = "rustdesk";
    desktopName = "RustDesk (X11)";
    comment = o.meta.description;
    genericName = "Remote Desktop";
    categories = ["Network"];
  })];
})
