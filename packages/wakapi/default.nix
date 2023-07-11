{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "sha256-rwQeIHJAtnRm5nPQCvgoBabVeyLZyrY3yglCW9+NGwM=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
