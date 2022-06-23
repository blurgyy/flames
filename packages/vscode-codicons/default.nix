{ stdenv, lib, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  pname = "vscode-codicons";
  version = "0.0.31";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "${pname}";
    rev = "refs/tags/${version}";
    sha256 = "sha256-b2irBe8+YG1qSEfQME8KzxrfOOBoemumMuzHrKmnrpg=";
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
