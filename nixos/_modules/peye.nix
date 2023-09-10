{ config, lib, pkgs, ... }:

let
  cfg = config.services.peye;
in

with lib;

{
  options.services.peye = {
    stream = mkEnableOption "Whether to enable streaming";
    record = mkEnableOption "Whether to enable recording";

    ffmpegPackage = mkOption {
      type = types.package;
      default = pkgs.ffmpeg-full;
    };

    # streaming options
    streamDevice = mkOption {
      type = types.str;
      description = "Video device to read input from";
    };
    streamHost = mkOption {
      type = types.str;
      description = "Address to listen on for the streamer";
    };
    streamPort = mkOption {
      type = types.str;
      description = "Port to bind for the streamer";
    };
    streamQuality = mkOption {
      type = types.int;
      description = ''
        JPEG quality for streaming, the receiving end can consume less CPU if this is set to a lower
        value.
      '';
      default = 40;
    };
    streamEncoder = mkOption {
      type = types.enum [ "CPU" "HW" "M2M-VIDEO" "M2M-Image" "NOOP" ];
      description = "Encoder for streaming";
    };
    streamAuthUsername = mkOption {
      type = types.str;
      description = "HTTP basic auth username";
      default = "peye";
    };
    streamAuthPassword = mkOption {
      type = types.str;
      description = "HTTP basic auth password";
      default = "peye";
    };
    streamFps = mkOption {
      type = types.int;
      description = "FPS for streaming, hardware may ignore this";
      default = 24;
    };

    # recording options
    recordUrl = mkOption {
      type = types.str;
      description = "Url to request for stream to save to local disk";
      example = "127.0.0.1:8080/stream";
      # no default, must set explicitly
    };
    recordAuthUsername = mkOption {
      type = types.str;
      description = "HTTP basic auth username";
      default = "peye";
    };
    recordAuthPassword = mkOption {
      type = types.str;
      description = "HTTP basic auth password";
      default = "peye";
    };
    recordCodec = mkOption {
      type = types.enum [
        "h264_v4l2m2m"
        "libx264"
        # "h264_vaapi"  # does not seem to work even with `-hwaccel vaapi -vaapi_device dev/dri/renderD128`
      ];
      description = "Encoder codec to use in ffmpeg";
    };
    chunkSeconds = mkOption {
      type = types.int;
      description = "Seconds of each saved mp4 file";
      default = 60 * 60;
    };
    graceSeconds = mkOption {
      type = types.int;
      description = "Seconds of overlap between consecutive saved mp4 files";
      default = 60;
    };
  };

  config = mkIf (cfg.stream || cfg.record) {
    assertions = [{
      assertion = !cfg.record || cfg.chunkSeconds >= 60 && cfg.graceSeconds >= 5;
      message = ''
        Length of each file (`chunkSeconds`) must be longer than 60 seconds, and overlapping seconds
        (`graceSeconds`) must be longer than 5 seconds.
        Got chunkSeconds=${toString cfg.chunkSeconds}, graceSeconds=${toString cfg.graceSeconds}.
      '';
    } {
      assertion = !cfg.stream || cfg.streamQuality <= 100 && cfg.streamQuality > 0;
      message = ''
        Streaming quality must be an integer in range (0, 100], got streamQuality=${cfg.streamQuality}
      '';
    }];

    environment.systemPackages = [
      pkgs.ustreamer
    ];
    users = {
      users.peye = {
        group = config.users.groups.peye.name;
        extraGroups = [
          config.users.groups.video.name  # for reading video device
        ];
        isSystemUser = true;
      };
      groups.peye = {};
    };
    systemd.targets.peye = {
      requires = [
        "network-online.target"
      ]
        ++ (optional cfg.stream "peye-stream.service")
        ++ (optional cfg.record "peye-record.service");
      wantedBy = [
        "multi-user.target"
      ];
    };
    systemd.services = let
      sharedServiceConfig = rec {
        User = config.users.users.peye.name;
        Group = config.users.groups.peye.name;
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        StateDirectory = "peye";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/${StateDirectory}";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        LimitNOFILE = 1000000007;
        Restart = "on-failure";
        RestartSec = 5;
      };
    in {
      peye-stream = mkIf cfg.stream {
        wantedBy = [ "peye.target" ];
        path = [ pkgs.ustreamer ];
        script = ''
          ustreamer \
            --device ${cfg.streamDevice} \
            --quality ${cfg.streamQuality} \
            --encoder ${cfg.streamEncoder} \
            --host ${cfg.streamHost} \
            --port ${cfg.streamPort} \
            --user ${cfg.streamAuthUsername} \
            --passwd ${cfg.streamAuthPassword} \
            --desired-fps ${toString cfg.streamFps} \
            --slowdown
        '';
        serviceConfig = sharedServiceConfig;
      };
      peye-record = mkIf cfg.record {
        wantedBy = [ "peye.target" ];
        path = with pkgs; [
          coreutils-full  # date, mkdir
          curl
          gnused  # sed
          gnugrep  # grep
          cfg.ffmpegPackage
        ];
        script = let
          save-single-chunk = pkgs.writeShellScript "save-single-chunk" ''
            set -x

            if [[ "$#" -ne 1 ]]; then
              >&2 echo "Usage: $0 <fps>"
              >&2 echo
              >&2 echo "  e.g. $0 25"
            fi

            fps="$1"
            dest_dir="''$(date +%Y-%m-%d)"
            dest="$dest_dir/$(date +%H-%M-%S).mp4"
            mkdir -p "$dest_dir"
            curl ${cfg.recordUrl} -u ${cfg.recordAuthUsername}:${cfg.recordAuthPassword} -s |
              ffmpeg -hide_banner \
                -use_wallclock_as_timestamps 1 \
                -i pipe: \
                -vf 'format=yuv420p,drawtext=text=%{localtime}:fontcolor=yellow:fontsize=24' \
                -frames:v "$(( fps * ${toString (cfg.chunkSeconds + cfg.graceSeconds)} ))" \
                -c:v ${cfg.recordCodec} \
                "$dest"
          '';
        in ''
          fps="''$(
            curl ${cfg.recordUrl} -u ${cfg.recordAuthUsername}:${cfg.recordAuthPassword} -s |
              ffprobe -i pipe: |&
              grep "\btbr\b" |
              sed -Ee 's/^.* ([^\s]+) tbr.*$/\1/'
          )"
          echo "FPS from stream is $fps"
          while true; do
            ${save-single-chunk} "$fps" &
            sleep ${toString cfg.chunkSeconds}s
          done
        '';
        serviceConfig = sharedServiceConfig;
      };
    };
  };
}
