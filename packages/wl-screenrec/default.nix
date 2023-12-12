{ source, lib, rustPlatform
, pkg-config
, ffmpeg
, libdrm
}:

rustPlatform.buildRustPackage {
  inherit (source) pname version src;

  cargoLock = source.cargoLock."Cargo.lock";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg.dev
    libdrm
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/russelltg/wl-screenrec";
    description = "High performance wlroots screen recording, featuring hardware encoding";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "wl-screenrec";
  };
}
