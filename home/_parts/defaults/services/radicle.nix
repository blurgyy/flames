{ myName, hostName, config, pkgs, ... }:

{
  home.packages = [ pkgs.radicle-node ];

  home.file = {
    radiclePrivKey = {
      source = config.lib.file.mkOutOfStoreSymlink config.sops.secrets."userKey/${myName}@${hostName}".path;
      target = ".radicle/keys/radicle";
    };
    radiclePubKey = {
      text = (import ../../../../nixos/_parts/defaults/public-keys.nix).users."${myName}@${hostName}";
      target = ".radicle/keys/radicle.pub";
    };
    radicleConfig = {
      text = ''{
        "publicExplorer": "https://git.blurgy.xyz/nodes/$host/$rid$path",
        "preferredSeeds": [
          "z6MkjXQGjLieiAijpGvX7kjkuEcmqQZK9MYA3oXtpLrqBbPD@radicle.blurgy.xyz:8776",
          "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776",
          "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@ash.radicle.garden:8776"
        ],
        "web": {
          "pinned": {
            "repositories": []
          }
        },
        "cli": {
          "hints": true
        },
        "node": {
          "alias": "highsunz",
          "listen": [],
          "peers": {
            "type": "dynamic"
          },
          "connect": [],
          "externalAddresses": [],
          "network": "main",
          "log": "INFO",
          "relay": "auto",
          "limits": {
            "routingMaxSize": 1000,
            "routingMaxAge": 604800,
            "gossipMaxAge": 1209600,
            "fetchConcurrency": 1,
            "maxOpenFiles": 4096,
            "rate": {
              "inbound": {
                "fillRate": 5.0,
                "capacity": 1024
              },
              "outbound": {
                "fillRate": 10.0,
                "capacity": 2048
              }
            },
            "connection": {
              "inbound": 128,
              "outbound": 16
            }
          },
          "workers": 8,
          "seedingPolicy": {
            "default": "block"
          }
        }
      }'';
      target = ".radicle/config.json";
    };
  };

  systemd.user.services.radicle-node = {
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart = "${pkgs.radicle-node}/bin/radicle-node";
      Restart = "always";
      RestartSec = 5;
      NoNewPriviledges = true;
    };
  };
}
