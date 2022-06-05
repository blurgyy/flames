{ stdenv, lib, fetchurl, ... }:
stdenv.mkDerivation rec {
  pname = "apple-color-emoji";
  version = "ios-15.4";
  src = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/${version}/AppleColorEmoji.ttf";
    sha256 = "0v4avyk76pw3bsi9p2hcg5qd5kdyvp5a0hy0r2cx1jp55hnasf88";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/truetype $src
  '';

  meta = {
    homepage = "https://github.com/samuelngs/${pname}";
    description = "Apple Color Emoji for Linux";
    license = lib.licenses.asl20;
  };
}
