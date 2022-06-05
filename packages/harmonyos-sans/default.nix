{ stdenv, lib, pkgs, fetchgit, ... }:
stdenv.mkDerivation rec {
  pname = "harmonyos-sans-git";
  version = "OpenHarmony-v3.0.2-LTS";
  src = fetchgit {
    url = "https://gitee.com/openharmony/resources";
    rev = "refs/tags/${version}";
    sha256 = "sha256-dbdrVMGEvFuy6lepWTgL4k5Fh5ToTXl8j80NZygL6n8=";
  };

  nativeBuildInputs = [ pkgs.unzip ];
  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/truetype -m444 $src/fonts/*
  '';

  meta = {
    homepage = "https://gitee.com/openharmony/resources";
    description = "HarmonyOS Fonts";
    license = lib.licenses.asl20;
  };
}
