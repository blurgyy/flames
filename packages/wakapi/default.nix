{ source, lib, buildGoModule }: buildGoModule rec {
  inherit (source) pname version src;
  vendorSha256 = "sha256-dbh0Kd0qzPJs1RMicLquH6ao7OlfvluDcNL0m2fWUg8=";

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
