{ source, lib, buildNpmPackage }: buildNpmPackage {
  inherit (source) pname version src;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  npmDepsHash = "sha256-LmC9BJNOmO/G17JQWQJtfTfpmnVyQA9iviYL6erLb8s=";

  meta = {
    homepage = "https://github.com/Leask/halbot";
    description = "Just another ChatGPT/Bing Chat Telegram bob, which is simple design, easy to use, extendable and fun.";
    license = lib.licenses.mit;
  };
}
