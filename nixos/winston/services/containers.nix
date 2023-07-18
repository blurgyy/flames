{ config, lib, pkgs, inputs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs) system config overlays;
  };
in

{
  systemd = {
    nspawn = let
      cudatoolkit-bindpath = "/opt/cuda";
      opengl-driver-bindpath = "/usr/lib/opengl-driver";
      authorized_keys-path = "/etc/ssh/authorized_keys";

      mkSshdConfigPortOverride = port: builtins.toFile "nspawn-sshd_config-port-override" ''
        Port ${toString port}
      '';
      tmpfiles-create-etc-sshd-authorized_keys = let
        keys = import ../../_parts/defaults/public-keys.nix;
      in with builtins;
        toFile "nspawn-tmpfiles-sshd-authorized_keys" ''
          f ${authorized_keys-path} 444 root root - ${lib.concatStringsSep "\\n" (attrValues keys.users)}
        '';
      sshd_config-overrides = builtins.toFile "nspawn-sshd_config-overrides" ''
        AuthorizedKeysFile %h/.ssh/authorized_keys /etc/ssh/authorized_keys.d/%u ${authorized_keys-path}
        PasswordAuthentication no
      '';
      tmpfiles-create-var-empty-directory = builtins.toFile "nspawn-tmpfiles-create-var-empty-directory" ''
        d /var/empty 0700 root root - -
      '';
      mkEtcHosts = hostname: builtins.toFile "nspawn-" ''
        127.0.0.1 localhost
        ::1 localhost
        127.0.0.2 ${hostname}
        ::1 ${hostname}
      '';
      tmpfiles-create-var-lib-systemd-linger-gy = builtins.toFile "nspawn-tmpfiles-create-var-lib-systemd-linger-gy" ''
        f /var/lib/systemd/linger/gy 0644 root root - -
      '';

      proxy-env = builtins.toFile "nspawn-proxy-env" ''
        export http_proxy=http://127.1:1990
        export https_proxy="$http_proxy"
      '';
      display-env = builtins.toFile "nspawn-display-env" ''
        export DISPLAY=:0
        export LD_LIBRARY_PATH="${opengl-driver-bindpath}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      '';
      cudatoolkit-unsplit = with pkgs-stable; symlinkJoin {
        name = "${cudatoolkit.name}-unsplit";
        paths = [ cudatoolkit.lib cudatoolkit.out ];
      };
      cuda-env = builtins.toFile "nspawn-cuda-env" ''
        export PATH="${cudatoolkit-bindpath}/bin''${PATH:+:$PATH}"
        export LD_LIBRARY_PATH="${opengl-driver-bindpath}:${cudatoolkit-bindpath}/lib64''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      '';
      conda-env = builtins.toFile "nspawn-codna-env" ''
        export PATH="$HOME/.conda/bin''${PATH:+:$PATH}"
      '';
      home-manager-PATH-env = builtins.toFile "nspawn-home-manager-PATH-env" ''
        if [[ -d "$HOME/.nix-profile/etc/profile.d" ]]; then
          for i in "$HOME"/.nix-profile/etc/profile.d/*.sh; do
            source "$i"
          done
          unset i
        fi
      '';
      # enable colors in tmux when using `ssh winston -t machinectl login <container>`
      TERM-env = builtins.toFile "nspawn-TERM-env" ''
        export TERM=xterm-256color
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
            "/broken:/broken:idmap"  # use `idmap` so that users inside container can write to it, for conda env, etc
            "/home/gy:/home/gy:idmap"  # `useradd gy -g 100 -G sudo,video`, to create a user with primary group id=100, supplementary groups "sudo" and "video"
            "/var/empty:/home/gy/.config/systemd"  # so that systemd does not run user services like git-sync inside the container
          ] ++ [
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
            "/etc/resolv.conf"
            "${mkEtcHosts "ubuntu-jammy"}:/etc/hosts"
            "${proxy-env}:/etc/profile.d/proxy-env.sh"
            # "${display-env}:/etc/profile.d/display-env.sh"
            "${cuda-env}:/etc/profile.d/cuda-env.sh"
            "${conda-env}:/etc/profile.d/conda-env.sh"
            "${home-manager-PATH-env}:/etc/profile.d/home-manager-PATH-env.sh"
            "${TERM-env}:/etc/profile.d/TERM-env.sh"
          ] ++ [  # ssh
            "${tmpfiles-create-etc-sshd-authorized_keys}:/etc/tmpfiles.d/create-etc-sshd-authorized_keys.conf"
            "${tmpfiles-create-var-empty-directory}:/etc/tmpfiles.d/create-var-empty-directory.conf"
            "${tmpfiles-create-var-lib-systemd-linger-gy}:/etc/tmpfiles.d/enable-lingering-gy.conf"
            # add a line to `/etc/ssh/sshd_config` inside the container:
            #   Include sshd_config.d/*
            "${sshd_config-overrides}:/etc/ssh/sshd_config.d/overrides.conf"
            "${mkSshdConfigPortOverride 1722}:/etc/ssh/sshd_config.d/port-override.conf"
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
      # WARN: apparently trying to use this to autostart the container on boot causes CUDA not being
      #       able to find any available device inside the container, not sure why.  The error
      #       messages:
      #         * nvidia-smi:
      #             Failed to initialize NVML: Unknown Error
      #         * CUDA:
      #             failed: no CUDA-capable device is detected
      #
      # "systemd-nspawn@jammy" = {
      #   overrideStrategy = "asDropin";
      #   wantedBy = [ "machines.target" ];
      # };
    };
  };
}
