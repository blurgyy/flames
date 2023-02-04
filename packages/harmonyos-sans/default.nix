{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm444 -t $out/share/fonts/truetype $src/fonts/*
  '';

  meta = {
    homepage = "https://gitee.com/openharmony/resources";
    description = "HarmonyOS Fonts";
    license = lib.licenses.asl20;
  };
}
