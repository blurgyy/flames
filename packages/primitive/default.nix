{ source, lib, buildGoModule }:

buildGoModule {
  inherit (source) pname version src;
  patches = [
    ./add-go-mod.patch
  ];
  vendorHash = "sha256-cdiBbMF1GkHmDG5w8RXxLoWXebnI+upQ0JjgluAGH9E=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/fogleman/primitive";
    description = "Reproducing images with geometric primitives.";
    license = lib.licenses.agpl3;
  };
}
