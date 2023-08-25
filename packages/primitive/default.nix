{ source, lib, buildGoModule }:

buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "";

  doCheck = false;

  meta = {
    homepage = "https://github.com/fogleman/primitive";
    description = "Reproducing images with geometric primitives.";
    license = lib.licenses.agpl3;
  };
}
