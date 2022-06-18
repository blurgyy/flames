{ pkgs, lib, fetchCrate, rustPlatform }: with pkgs; rustPlatform.buildRustPackage rec {
  pname = "rathole";
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-qzeR9fbDenXSYAM9ymjhr63UUQ4pDf8/2LP0HE+e5ao=";
  };
  cargoSha256 = "sha256-ImBx2wKZzEXWxNvfu/2Dj/cyY3v5GZNwsPM3XM1Otxg=";
  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  doCheck = false;

  meta = {
    description = "A lightweight and high-performance reverse proxy for NAT traversal, written in Rust. An alternative to frp and ngrok.";
    homepage = "https://github.com/rapiz1/rathole";
    license = lib.licenses.asl20;
  };
}
