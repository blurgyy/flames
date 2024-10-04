{ radicle-explorer
, jq
}:

radicle-explorer.overrideAttrs (o: {
  postPatch = o.postPatch or "" + ''
    ${jq}/bin/jq '.preferredSeeds |= [{
      "hostname": "radicle.blurgy.xyz",
      "port": 443,
      "scheme": "https"
    }] + .' config/default.json >config/local.json
  '';
})
