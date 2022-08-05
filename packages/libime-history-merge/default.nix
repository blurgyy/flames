{ source, lib, rustPlatform }: rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  meta = {
    description = "Merge fcitx5 histories from multiple machines";
    homepage = "https://github.com/blurgyy/libime-history-merge";
    license = lib.licenses.lgpl21;
  };
}
