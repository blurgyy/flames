{ pkgs, ... }: let
  listenPort = 16826;
in {
  systemd.services.router-page = rec {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.dufs ];
    preStart = ''
      cd /run/${serviceConfig.RuntimeDirectory}
      cat >index.html <<EOF
<html>
  <head>
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7603222628125848" crossorigin="anonymous"></script>
    <meta charset="utf8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
  </head>
  <body style="font-family: monospace;">
    <p>
      This page is a router.
      You may find:
    </p>
    <p>
      <ul>
        <li> Blog: &lt;<a href="https://gy.blurgy.xyz/">gy.blurgy.xyz</a>&gt; </li> 
        <li> Coding activities: &lt;<a href="https://codingstats.blurgy.xyz/leaderboard">codingstats.blurgy.xyz</a>&gt; </li>
        <li> Hydra (Nix-based CI): &lt;<a href="https://hydra.blurgy.xyz/">hydra.blurgy.xyz</a>&gt; </li> 

        <li> E-Mail: &lt;<a href="mailto:gy@blurgy.xyz">gy@blurgy.xyz</a>&gt; </li>
      </ul>
    </p>
  <body>
</html>
EOF
      cat >ads.txt <<EOF
google.com, pub-7603222628125848, DIRECT, f08c47fec0942fa0
EOF
    '';
    script = ''
      dufs /run/${serviceConfig.RuntimeDirectory} --render-index \
        -p ${toString listenPort} \
        --log-file /var/log/${serviceConfig.LogsDirectory}/router-page.log
    '';
    serviceConfig = {
      DynamicUser = true;
      RuntimeDirectory = "router-page";
      RuntimeDirectoryMode = "0700";
      LogsDirectory = "router-page";
      LogsDirectoryMode = "0700";
      Restart = "always";
      RestartSec = 5;
    };
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [
      { name = "router-page"; isDefault = true; }
    ];
    backends.router-page = {
      mode = "http";
      server.address = "127.0.0.1:${toString listenPort}";
      requestRules = [ "replace-uri /.*$ /index.html" ];
    };
  };
}
