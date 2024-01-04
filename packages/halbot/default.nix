{ source, lib, buildNpmPackage }: buildNpmPackage {
  inherit (source) pname version src;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  npmDepsHash = "sha256-qH8oRCYn42Nef9Tt4cfta4sFUkD3aRUkJL4kL9cxzx0=";
  makeCacheWritable = true;
  # npmFlags = [ "--legacy-peer-deps" ];

  meta = {
    homepage = "https://github.com/Leask/halbot";
    description = "Just another ChatGPT/Bing Chat Telegram bob, which is simple design, easy to use, extendable and fun.";
    license = lib.licenses.mit;
  };
}
