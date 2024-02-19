{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-TeKVhG1V9inyDWfILwtpU9QknJ9bt3Dja5GVHrK9PkA=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = lib.licenses.gpl3;
  };
}
