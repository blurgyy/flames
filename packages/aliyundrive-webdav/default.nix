{ source, lib, rustPlatform
, pkgconfig
, fuse
}: rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse ];

  meta = {
    description = "阿里云盘 WebDAV 服务";
    homepage = "https://github.com/messense/aliyundrive-webdav";
    license = lib.licenses.mit;
  };
}
