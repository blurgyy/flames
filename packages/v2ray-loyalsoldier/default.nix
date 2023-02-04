{ v2ray, loyalsoldier-geodata }: v2ray.overrideAttrs (oldAttrs: {
  pname = "v2ray-loyalsoldier";
  assetsDrv = loyalsoldier-geodata;
})
