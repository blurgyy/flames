{ source, lib, rustPlatform }: rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  buildFeatures = [ "geoip-cn" ];

  meta = {
    description = "A high-performance programmable DNS component aiming at robustness, speed, and flexibility";
    homepage = "https://github.com/compassd/dcompass";
    license = lib.licenses.mit;
  };
}
