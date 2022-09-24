{ source, stdenv, lib }: stdenv.mkDerivation rec {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/fonts/truetype -m444 $src/fonts/*
  '';

  meta = {
    homepage = "https://gitee.com/openharmony/resources";
    description = "HarmonyOS Fonts";
    license = lib.licenses.asl20;
  };
}
