{ system, lib, fetchurl, appimageTools }:
let
  architecture = builtins.head (lib.strings.splitString "-" system);
  pname = "dingtalk";
  version = "2.1.19";
  src = fetchurl {
    url = "https://github.com/nashaofu/dingtalk/releases/download/v${version}/${pname}-${version}-latest-${architecture}.AppImage";
    sha256 = "sha256-Iq/GVKgtx0mwJvfn2C+MwfTm8ZPfpo7KZCvMd/1KN6I=";
  };
in appimageTools.wrapType2 {
  inherit pname version src;
  name = pname;
  meta = {
    description = "DingTalk desktop messaging application";
    homepage = "https://www.dingtalk.com/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
