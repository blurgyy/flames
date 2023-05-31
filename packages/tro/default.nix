{ source, lib, rustPlatform
, pkg-config
, openssl
}: rustPlatform.buildRustPackage {
  inherit (source) pname version src;

  cargoHash = "sha256-iyrnaxYP4x1Q8WqM+xV4Gj4ykTshL42mrj6vQotPXmI=";

  cargoPatches = [
    ./update-cargo-lock.patch
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl.dev ];

  meta = {
    homepage = "https://github.com/MichaelAquilina/tro";
    description = "Trello command line utility written in Rust";
    license = lib.licenses.gpl3;
  };
}
