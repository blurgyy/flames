{ source, lib, rustPlatform
, openssl
, pkg-config
}: rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  doCheck = false;

  meta = {
    description = "A lightweight and high-performance reverse proxy for NAT traversal, written in Rust. An alternative to frp and ngrok.";
    homepage = "https://github.com/rapiz1/rathole";
    license = lib.licenses.asl20;
  };
}
