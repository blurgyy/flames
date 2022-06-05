{ stdenv, lib, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  pname = "vscode-codicons";
  version = "0.0.29";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "${pname}";
    rev = "refs/tags/${version}";
    sha256 = "0aixld6jajfjbygbz6878004j85d0cm06jplg6ajw4czjaiiiv1m";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/truetype $src/dist/codicon.ttf
    install -Dt $out/share/doc/${pname} $src/dist/codicon.{css,csv,html,svg}
  '';

  meta = {
    homepage = "https://github.com/microsoft/${pname}";
    description = "The icon font for Visual Studio Code";
    license = lib.licenses.cc-by-nc-sa-40;
  };
}
