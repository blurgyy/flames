{ source, lib, rustPlatform
, libxkbcommon
}:

rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  buildInputs = [
    libxkbcommon
  ];

  meta = {
    description = "Wayland clone of keynav";
    homepage = "https://github.com/tadeokondrak/waypoint";
    license = lib.licenses.mpl20;
  };
}
