{ stdenvNoCC
, python3
, dbus
, systemd
, makeWrapper
}:

let
  mainProgram = "run";
in

stdenvNoCC.mkDerivation {
  name = "setup-xdg-desktop-portal-env-script";

  buildInputs = [
    python3
    makeWrapper
  ];

  buildCommand = ''
    install -Dvm555 ${./main.py} $out/bin/${mainProgram}
    patchShebangs --build $out
    wrapProgram $out/bin/${mainProgram} \
      --prefix PATH : ${dbus}/bin \
      --prefix PATH : ${systemd}/bin
  '';

  meta = {
    homepage = "https://github.com/emersion/xdg-desktop-portal-wlr/wiki/%22It-doesn't-work%22-Troubleshooting-Checklist";
    description = "Fixes flameshot not being activated in sway";
    inherit mainProgram;
  };
}
