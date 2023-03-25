{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "sha256-0wHXULDKyXYBTGxfSQXT/5NidPtSnx7ujb8vyczmE38=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
