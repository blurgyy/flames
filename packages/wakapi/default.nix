{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-RG6lc2axeAAPHLS1xRh8gpV/bcnyTWzYcb1YPLpQ0uQ=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
