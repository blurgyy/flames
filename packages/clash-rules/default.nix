{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "clash-rules";
  version = "0.1.0";
  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;
}
