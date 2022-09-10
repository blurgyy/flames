{ symlinkJoin, stdenv
, v2ray
, loyalsoldier-geodata
}: v2ray.overrideAttrs (oldAttrs: {
  pname = "v2ray-loyalsoldier";
  buildCommand = ''
    for file in ${oldAttrs.passthru.core}/bin/*; do
      makeWrapper "$file" "$out/bin/$(basename "$file")" \
        --set-default V2RAY_LOCATION_ASSET ${loyalsoldier-geodata}/share/v2ray
    done
  '';
})
