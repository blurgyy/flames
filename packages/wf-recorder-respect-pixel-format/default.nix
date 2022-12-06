{ wf-recorder
, fetchpatch
}: wf-recorder.overrideAttrs (o: {
  pname = o.pname + "-respect-pixel-format";
  patches = o.patches or [] ++ [
    (fetchpatch {
      name = "respect-pixel-format-patch";
      url = "https://github.com/ammen99/wf-recorder/commit/e7512572ca4a35de7ac62a6b8858a77143568a71.patch";
      hash = "sha256-KonOAquC1guHDuZ/E0bRgNad3M+VgYKlSzwFeERmZh4=";
    })
  ];
})
