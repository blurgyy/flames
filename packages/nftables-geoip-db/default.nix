{ source, stdenv, lib
, gzip
, perl
, perlPackages
}: let
  perlBuilder = perl.withPackages (pp: with pp; [ TextCSV_XS NetCIDRLite ]);
in stdenv.mkDerivation {
  inherit (source) pname version src;

  unpackPhase = "${gzip}/bin/gunzip -c $src >geoip.csv";
  buildPhase = ''
    mkdir nftables-geoip-db
    # Add single quotes to the "EOF" below to avoid escape backslashes/backticks in heredoc
    # REF: <https://stackoverflow.com/questions/30998588/how-to-handle-backslash-escape-characters-in-q-string-and-heredocument>
    # REF: <https://stackoverflow.com/questions/13122147/prevent-expressions-enclosed-in-backticks-from-being-evaluated-in-heredocs#comment64613326_13122217>
    cat >build.pl <<'EOF'
${builtins.readFile ./build.pl}
EOF
    ${perlBuilder}/bin/perl build.pl \
      -D nftables-geoip-db \
      -i geoip.csv
  '';
  installPhase = ''
    mkdir -p $out/share
    mv nftables-geoip-db $out/share
  '';

  meta = {
    homepage = "https://db-ip.com/db/download/ip-to-country-lite";
    description = "GeoIP Database for nftables";
    license = lib.licenses.cc-by-40;
  };
}
