{ generated, lib, buildNpmPackage
, coreutils-full
}:

buildNpmPackage {
  pname = "sshx-frontend";
  inherit (generated.sshx) version src;

  nativeBuildInputs = [ coreutils-full ];
  patches = [ ./get-version-from-env.patch ];

  npmDepsHash = "sha256-bKePCxo6+n0EG+4tbbMimPedJ0Hu1O8yZsgspmhobOs=";

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    dest=$out/share/webapps/sshx
    mkdir -p "$(dirname "$dest")"
    cp -vr build $dest
  '';

  meta = {
    homepage = "https://github.com/ekzhang/sshx";
    description = "Fast, collaborative live terminal sharing over the web";
    license = lib.licenses.mit;
  };
}
