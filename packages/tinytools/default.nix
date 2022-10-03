{ source, lib, rustPlatform }: rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  meta = {
    description = "A collection of tools that enhance your experience in shell.";
    homepage = "https://github.com/blurgyy/tinytools";
    mainProgram = "tt";
    license = lib.licenses.mit;
  };
}
