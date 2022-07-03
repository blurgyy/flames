{ source, pkgs, lib }: with pkgs; rustPlatform.buildRustPackage rec {
  inherit (source) pname version src;

  cargoLock.lockFileContents = source."Cargo.lock";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  doCheck = false;

  meta = {
    description = "A lightweight and high-performance reverse proxy for NAT traversal, written in Rust. An alternative to frp and ngrok.";
    homepage = "https://github.com/rapiz1/rathole";
    license = lib.licenses.asl20;
  };
}
