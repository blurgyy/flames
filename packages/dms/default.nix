{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "sha256-Z0DoVmL0zJ4l9hrO+zGp6FcExvhbiPu5+N3Mfyxi5DE=";

  meta = {
    homepage = "https://github.com/anacrolix/dms";
    description = "A UPnP DLNA Digital Media Server that includes basic video transcoding. Tested on a Panasonic Viera television, several Android UPnP apps, and Chromecast.";
    license = lib.licenses.gpl3;
  };
}
