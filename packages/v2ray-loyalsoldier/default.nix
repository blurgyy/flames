{ v2ray, symlinkJoin, stdenv, fetchurl }: let
  tag = "202206122211";
  loyalsoldier-geoip = stdenv.mkDerivation {
    pname = "loyalsoldier-geoip";
    version = tag;
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${tag}/geoip.dat";
      sha256 = "sha256-yrpIOc0Re/TpKWQuwHqImCJfKX/OSXNHUP9msYAKRdg=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      install -m 0644 $src -D $out/share/v2ray/geoip.dat
    '';
  };
  loyalsoldier-geosite = stdenv.mkDerivation {
    pname = "loyalsoldier-geosite";
    version = tag;
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${tag}/geosite.dat";
      sha256 = "sha256-oxiNNPp9FQMgb/ypixlkPbDy0UepuJNEXKDxavjt7IE=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      install -m 0644 $src -D $out/share/v2ray/geosite.dat
    '';
  };
  assetsDrv = symlinkJoin {
    name = "v2ray-loyalsoldier-assets";
    paths = [ loyalsoldier-geoip loyalsoldier-geosite ];
  };
in v2ray.overrideAttrs (oldAttrs: {
  pname = "v2ray-loyalsoldier";
  buildCommand = ''
    for file in ${oldAttrs.passthru.core}/bin/*; do
      makeWrapper "$file" "$out/bin/$(basename "$file")" \
        --set-default V2RAY_LOCATION_ASSET ${assetsDrv}/share/v2ray
    done
  '';
})
