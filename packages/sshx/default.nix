{ source, lib, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  nativeBuildInputs = [ protobuf ];

  patches = [ ./allow-specifying-root-serving-directory.patch ];

  meta = {
    homepage = "https://github.com/ekzhang/sshx";
    description = "Fast, collaborative live terminal sharing over the web";
    license = lib.licenses.mit;
  };
}
