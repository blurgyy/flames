{ source, lib, buildNpmPackage }: buildNpmPackage {
  inherit (source) pname version src;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  npmDepsHash = "sha256-kpmeTGo8+JKg1FPfGdmlEav0eoeZA63xtEfnFBHYrUw=";
  makeCacheWritable = true;
  # npmFlags = [ "--legacy-peer-deps" ];

  meta = {
    homepage = "https://github.com/Leask/halbot";
    description = "Just another ChatGPT/Bing Chat Telegram bob, which is simple design, easy to use, extendable and fun.";
    license = lib.licenses.mit;
  };
}