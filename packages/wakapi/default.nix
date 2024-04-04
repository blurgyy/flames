{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-pRj7Y2xp+Z2StaXRIzI5b2WAkIhR9y8T8DMXWrxOiy4=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = lib.licenses.gpl3;
  };
}
