{ source, stdenvNoCC, lib, ... }: stdenvNoCC.mkDerivation rec {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm444 $src $out/share/fonts/truetype/AppleColorEmoji.ttf
  '';

  meta = {
    homepage = "https://github.com/samuelngs/${pname}";
    description = "Apple Color Emoji for Linux";
    license = lib.licenses.asl20;
  };
}
