{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "sing-box-rules";
  version = "0.1.0";
  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;
}
