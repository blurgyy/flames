{ source, lib, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;

  buildFlags = [
    "PREFIX=$(out)"
    "confdir=/etc"
  ];

  # REF: <https://github.com/nbfc-linux/nbfc-linux/blob/main/flake.nix>
  installPhase = ''
    make PREFIX=$out \
      install-core \
      install-client-c \
      install-configs \
      install-docs \
      install-completion
  '';

  meta = {
    homepage = "https://github.com/nbfc-linux/nbfc-linux";
    description = "NoteBook FanControl ported to Linux";
    license = lib.licenses.gpl3;
  };
}
