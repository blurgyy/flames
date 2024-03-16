{ generated, source, lib, python3Packages
, onnxruntime
, qt5
}:

let
  imgviz = python3Packages.buildPythonPackage {
    inherit (generated.imgviz) pname version src;

    propagatedBuildInputs = with python3Packages; [
      matplotlib
      numpy
      pillow
      pyyaml
    ];

    nativeCheckInputs = with python3Packages; [
      pytestCheckHook
    ];

    meta = {
      homepage = "https://github.com/wkentaro/imgviz";
      description = "Image Visualization Tools (object detection, semantic and instance segmentation)";
      license = lib.licenses.mit;
    };
  };

  pyonnxruntime = python3Packages.onnxruntime;
in

python3Packages.buildPythonApplication {
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

  propagatedBuildInputs = (with python3Packages; [
    gdown
    imgviz
    matplotlib
    natsort
    numpy
    pillow
    pyyaml
    qtpy
    scikit-image
    termcolor
    pyqt5
  ]) ++ [
    (pyonnxruntime.override { onnxruntime = onnxruntime.override { cudaSupport = false; }; })
  ];

  meta = {
    homepage = "https://github.com/wkentaro/labelme";
    description = "Image Polygonal Annotation with Python (polygon, rectangle, circle, line, point and image-level flag annotation).";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
