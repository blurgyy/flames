{ makeWrapper, stdenvNoCC
, python3
}: stdenvNoCC.mkDerivation {
  name = "genJqSecretsReplacementSnippet";
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    install -Dvm555 ${./src/do} $out/bin/do
    wrapProgram $out/bin/do \
      --prefix PATH : ${python3}/bin
  '';
}
