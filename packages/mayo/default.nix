{ source, lib, stdenv
, cmake
, qt6
, assimp
, opencascade-occt
}:

stdenv.mkDerivation {
  inherit (source) pname version src;

  patches = [
    ./add-cmake-install-rules.patch
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    assimp
    opencascade-occt
    qt6.qt5compat
  ];

  meta = {
    description = "3D CAD viewer and converter based on Qt + OpenCascade";
    homepage = "https://github.com/fougue/mayo";
    license = lib.licenses.bsd2;
  };
}
