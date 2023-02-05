{ source, lib, rustPlatform
, pkgconfig
, fuse
}: rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse ];

  meta = {
    description = "阿里云盘 FUSE 磁盘挂载";
    homepage = "https://github.com/messense/aliyundrive-fuse";
    license = lib.licenses.mit;
  };
}
