{ ffmpeg-full
, amf-headers
}: ffmpeg-full.overrideAttrs (o: {
  pname = "ffmpeg-fuller";
  buildInputs = o.buildInputs ++ [
    amf-headers
  ];
  configureFlags = o.configureFlags ++ [
    "--enable-amf"  # enables codec "h264_amf"
  ];

  meta.description = o.meta.description + " (with amf)";
})
