{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "sha256-uVdjMgQ1zWFKNwTKIHd7O47oekE9tLBh8LgFgI1SATM=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
