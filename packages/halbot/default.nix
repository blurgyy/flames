{ source, lib, buildNpmPackage }: buildNpmPackage {
  inherit (source) pname version src;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  npmDepsHash = "sha256-5zU0v+g3FMXNWM10Ly73Y3TeCd1G5FjluPPC/1CR+FM=";

  meta = {
    homepage = "https://github.com/Leask/halbot";
    description = "Just another ChatGPT/Bing Chat Telegram bob, which is simple design, easy to use, extendable and fun.";
    license = lib.licenses.mit;
  };
}
