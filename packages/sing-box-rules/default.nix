{ rustPlatform
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage {
  pname = "sing-box-rules";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoLock.lockFile = ./Cargo.lock;
}
