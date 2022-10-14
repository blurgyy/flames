{ source, lib, rustPlatform }: rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  meta = {
    description = "$HOME, $HOME everywhere";
    homepage = "https://github.com/blurgyy/dt";
    license = lib.licenses.mit;
  };
}
