{ generated, source, lib, python3Packages
, qt5
}:

with python3Packages;

let
  imgviz = buildPythonPackage {
    inherit (generated.imgviz) pname version src;

    propagatedBuildInputs = [
      matplotlib
      numpy
      pillow
      pyyaml
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    meta = {
      homepage = "https://github.com/wkentaro/imgviz";
      description = "Image Visualization Tools (object detection, semantic and instance segmentation)";
      license = lib.licenses.mit;
    };
  };
in

buildPythonApplication {
  inherit (source) pname version src;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];
  dontWrapQtApps = true;
  preFixup = ''
    for i in $out/bin/*; do
      wrapQtApp "$i" \
        --set QT_QPA_PLATFORM xcb
    done
  '';

  propagatedBuildInputs = [
    gdown
    imgviz
    matplotlib
    natsort
    numpy
    onnxruntime
    pillow
    pyyaml
    qtpy
    scikit-image
    termcolor
    pyqt5
  ];

  meta = {
    homepage = "https://github.com/wkentaro/labelme";
    description = "Image Polygonal Annotation with Python (polygon, rectangle, circle, line, point and image-level flag annotation).";
    license = lib.licenses.gpl3;
  };
}
