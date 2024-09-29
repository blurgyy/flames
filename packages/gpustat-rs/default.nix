{ lib, fetchCrate, rustPlatform }: rustPlatform.buildRustPackage rec {
  pname = "gpustat-rs";
  version = "0.1.4";
  cargoHash = "sha256-aoH5Yoa6jAVMmB38nEd7LUbKjpG41idfj7ReX/JkFR0=";

  src = fetchCrate {
    pname = "gpustat";
    inherit version;
    sha256 = "sha256-TSqxHuvAcujCqJpGFItTOlfB0J9Bo8GZP3GkhKtgqQ0=";
  };

  meta = {
    description = "A simple command-line utility for querying and monitoring GPU status";
    homepage = "https://github.com/AlongWY/gpustat";
    mainProgram = "gpustat";
    license = lib.licenses.gpl2;
  };
}
