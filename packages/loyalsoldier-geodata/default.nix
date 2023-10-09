{ symlinkJoin
, loyalsoldier-geoip
, loyalsoldier-geosite
}:

let
  joined = symlinkJoin {
    name = "loyalsoldier-geodata";
    paths = [ loyalsoldier-geoip loyalsoldier-geosite ];
  };
in

joined.overrideAttrs (o: {
  buildCommand = o.buildCommand + ''
    mkdir $out/nix-support -p
    cat >$out/nix-support/hydra-build-products <<EOF
    file binary-dist $out/share/v2ray/geoip.dat
    file binary-dist $out/share/v2ray/geosite.dat
    EOF
  '';
})
