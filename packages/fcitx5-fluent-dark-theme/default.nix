{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "fcitx5-fluent-dark-theme";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "FluentDark-fcitx5";
    rev = "77556203063760d87b87fb0b3b82f14cbe190193";
    sha256 = "0iasn5h3w7dhj30klaws4ay5vabgi89w3avn0n2lk9ndlliy6vd2";
  };
  phases = [ "installPhase" ];
  installPhase = ''
    install -dm755 $out/share/fcitx5/themes
    cp -rv $src/FluentDark $out/share/fcitx5/themes
  '';

  meta = {
    homepage = "https://github.com/Reverier-Xu/FluentDark-fcitx5";
    description = "A Fluent-Design dark theme with blur effect and shadow";
    license = null;
  };
}
