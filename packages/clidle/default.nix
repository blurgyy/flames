{ source, lib, buildGoModule }:

buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-YophzzTilKg+7QhthBr4G6vJBGt6l+9Y+I5E8Umuo8U=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/ajeetdsouza/clidle";
    description = "Play Wordle over SSH";
    license = lib.licenses.mit;
  };
}
