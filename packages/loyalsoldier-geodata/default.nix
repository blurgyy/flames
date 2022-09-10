{ symlinkJoin
, loyalsoldier-geoip
, loyalsoldier-geosite
}: symlinkJoin {
  name = "loyalsoldier-geodata";
  paths = [ loyalsoldier-geoip loyalsoldier-geosite ];
}
