{ config, ... }: {
  systemd = {
    nspawn = let
      proxy-env = builtins.toFile "nspawn-proxy-env" ''
        export http_proxy=http://127.1:1990
        export https_proxy="$http_proxy"
      '';
    in {
      # Installing:
      #   curl https://hub.nspawn.org/storage/ubuntu/jammy/tar/image.tar.xz -Lo /tmp/jammy.tar.xz
      #   machinectl import-tar /tmp/jammy.tar.xz jammy
      # To remove it completely:
      #   machinectl remove jammy
      jammy = {
        enable = true;
        execConfig.Boot = true;
        networkConfig.Private = false;
        filesConfig = {
          Bind = [
            "/dev/dri"
            "/dev/shm"
            "/dev/nvidia-modeset"
            "/dev/nvidia0"
            "/dev/nvidiactl"
          ] ++ (with config.boot.kernelPackages; [
            "${nvidia_x11.bin}/bin/nvidia-smi:/usr/bin/nvidia-smi"  # NOTE: also bind /nix:/nix so that dynamic libararies can be found
          ]);
          BindReadOnly = [
            "/nix"  # NOTE: this is required for the `nvidia-smi` binary from host machine to work
            "/:/host"
          ] ++ [
            "/etc/inputrc"
            "${proxy-env}:/etc/profile.d/proxy-env.sh"
          ];
        };
      };
    };
    services = {
      "systemd-nspawn@".serviceConfig = {
        DeviceAllow = [
          "char-drm rwx"
          "/dev/dri rw"
          "/dev/nvidia-modeset rw"
          "/dev/nvidia0 rw"
          "/dev/nvidiactl rw"
        ];
      };
    };
  };
}
