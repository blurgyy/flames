{ pkgs, ... }: let
  listenPort = 16826;
in {
  systemd.services.router-page = rec {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.thttpd ];
    preStart = ''
      cd /run/${serviceConfig.RuntimeDirectory}
      cat >index.html <<EOF
<html>
  <head>
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
    '';
    script = ''
      thttpd \
        -d /run/${serviceConfig.RuntimeDirectory} \
        -p ${toString listenPort} \
        -c "/index.html" \
        -l /var/log/${serviceConfig.LogsDirectory}/router-page.log \
        -D
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
