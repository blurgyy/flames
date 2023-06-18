{ source, lib, stdenv, symlinkJoin
, ffmpeg
, SDL2_ttf
, SDL2
}:

let
  SDL2-joined = symlinkJoin {
    name = "SDL2-joined";
    paths = [ SDL2_ttf SDL2.dev ];
  };
in

stdenv.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [
    ffmpeg.dev
    SDL2-joined
  ];

  preBuild = ''
    export MAKEFLAGS="$MAKEFLAGS -j$NIX_BUILD_CORES"
  '';
  installPhase = ''
    install -Dvm555 -t $out/bin video-compare
  '';

  meta = {
    homepage = "https://github.com/pixop/video-compare";
    license = lib.licenses.gpl2;
    description = "Split screen video comparison tool using FFmpeg and SDL2";
  };
}
