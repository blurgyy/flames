{ config, pkgs, ... }: {
  systemd = {
    nspawn = let
      cudatoolkit-bindpath = "/opt/cuda";
      opengl-driver-bindpath = "/usr/lib/opengl-driver";

      proxy-env = builtins.toFile "nspawn-proxy-env" ''
        export http_proxy=http://127.1:1990
        export https_proxy="$http_proxy"
      '';
      display-env = builtins.toFile "nspawn-display-env" ''
        export DISPLAY=:0
        export LD_LIBRARY_PATH="${opengl-driver-bindpath}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      '';
      cudatoolkit-unsplit = with pkgs; symlinkJoin {
        name = "${cudatoolkit.name}-unsplit";
        paths = [ cudatoolkit.lib cudatoolkit.out ];
      };
      cuda-env = builtins.toFile "nspawn-cuda-env" ''
        export PATH="${cudatoolkit-bindpath}/bin''${PATH:+:$PATH}"
        export LD_LIBRARY_PATH="${cudatoolkit-bindpath}/lib64''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      '';
    in {
      # See <https://nspawn.org> for available images.  Taking ubuntu "jammy" as an example,
      #
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
            "/dev/nvidia-uvm"  # NOTE: *required*, otherwise may encounter error like "cudaStreamCreate(&m_stream) failed: unknown error"
            "/dev/nvidia-uvm-tools"
          ];
          BindReadOnly = [
            "/nix"
            "/:/host"
            "/tmp/.X11-unix"
            "/etc/inputrc"
            "${proxy-env}:/etc/profile.d/proxy-env.sh"
            "${display-env}:/etc/profile.d/display-env.sh"
            "${cuda-env}:/etc/profile.d/cuda-env.sh"
          ] ++ (with config.boot.kernelPackages; [
            "${cudatoolkit-unsplit}:${cudatoolkit-bindpath}"
            "${nvidia_x11.bin}/bin/nvidia-smi:/usr/bin/nvidia-smi"  # NOTE: also bind /nix:/nix (see above) so that dynamic libararies can be found
            "/run/opengl-driver/lib:${opengl-driver-bindpath}"
          ]);
        };
      };
    };
    services = {
      "systemd-nspawn@".serviceConfig = {
        DeviceAllow = [
          "char-drm rwx"
          "/dev/dri rw"
          "/dev/shm rw"
          "/dev/nvidia-modeset rw"
          "/dev/nvidia0 rw"
          "/dev/nvidiactl rw"
          "/dev/nvidia-uvm rw"  # NOTE: *required*, otherwise may encounter error like "cudaStreamCreate(&m_stream) failed: unknown error"
          "/dev/nvidia-uvm-tools rw"
        ];
      };
    };
  };
}
