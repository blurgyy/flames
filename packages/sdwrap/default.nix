{ stdenvNoCC, rustPlatform, symlinkJoin
, pkg-config
, systemd
}: let
  sdwrap = rustPlatform.buildRustPackage {
    name = "sdwrap";
    src = ./.;

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ systemd.dev ];

    cargoLock.lockFile = ./Cargo.lock;
  };
  sdwrap-fish-completions = stdenvNoCC.mkDerivation {
    name = "sdwrap-fish-completions";
    src = ./src/fish-completions;
    buildCommand = ''
      install -Dvm555 -t $out/share/fish/vendor_completions.d $src/*
    '';
  };
in symlinkJoin {
  name = "sdwrap";
  paths = [ sdwrap sdwrap-fish-completions ];
}
