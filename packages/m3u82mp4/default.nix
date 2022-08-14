{ stdenv
, bash
, ffmpeg
, lsof
}: stdenv.mkDerivation {
  name = "m3u82mp4";
  src = ./m3u82mp4;
  phases = [ "installPhase" ];

  inherit bash ffmpeg lsof;

  installPhase = ''
    install -Dm555 $src $out/bin/m3u82mp4
    substituteAllInPlace $out/bin/m3u82mp4
  '';
}
