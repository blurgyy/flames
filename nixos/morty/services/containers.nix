{ config, lib, ... }:

let
  hostname = "juno";
in

{
  systemd = {
    nspawn = let
      opengl-driver-bindpath = "/usr/lib/opengl-driver";
      authorized_keys-path = "/etc/ssh/authorized_keys";

      mkSshdConfigPortOverride = port: builtins.toFile "nspawn-sshd_config-port-override" ''
        Port ${toString port}
      '';
      sshd_config-overrides = builtins.toFile "nspawn-sshd_config-overrides" ''
        AuthorizedKeysFile %h/.ssh/authorized_keys /etc/ssh/authorized_keys.d/%u ${authorized_keys-path}
        PasswordAuthentication no
      '';
      tmpfiles-create-var-empty-directory = builtins.toFile "nspawn-tmpfiles-create-var-empty-directory" ''
        d /var/empty 0700 root root - -
      '';
      mkEtcHosts = hostname: builtins.toFile "nspawn-etc-hosts-${hostname}" ''
        127.0.0.1 localhost
        ::1 localhost
        127.0.0.2 ${hostname}
        ::1 ${hostname}
      '';
      mkEtcHostname = hostname: builtins.toFile "nspawn-etc-hostname-${hostname}" ''
        ${hostname}
      '';
      tmpfiles-create-var-lib-systemd-linger-gy = builtins.toFile "nspawn-tmpfiles-create-var-lib-systemd-linger-gy" ''
        f /var/lib/systemd/linger/gy 0644 root root - -
      '';

      proxy-env = builtins.toFile "nspawn-proxy-env"
        (lib.concatStringsSep "\n"
          (builtins.attrValues
            (builtins.mapAttrs
              (name: value: "export ${name}=${value}")
              config.networking.proxy.envVars
            )
          )
        );
      display-env = builtins.toFile "nspawn-display-env" ''
        export DISPLAY=:0
        export LD_LIBRARY_PATH="${opengl-driver-bindpath}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
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
      ${hostname} = {
        enable = true;
        execConfig.Boot = true;
        networkConfig.Private = false;

        # # This requires the mapped user to have a private group (i.e. a group with same name as
        # # the user), e.g. gy:gy, NixOS currently does not support that.
        # filesConfig.BindUser = "gy";  # must also enable PrivateUsers, see systemd.nspawn(5) and systemd-nspawn(1)
        # execConfig.PrivateUsers = "pick";  # cannot specify `true` here

        filesConfig = {
          Bind = [
            "/home/gy:/home/gy:idmap"  # `useradd gy -g 100 -G sudo,video`, to create a user with primary group id=100, supplementary groups "sudo" and "video"
            "/var/empty:/home/gy/.config/systemd"  # so that systemd does not run user services like git-sync inside the container
          ] ++ [
            "/dev/dri"
            "/dev/shm"
          ];
          BindReadOnly = [
            "/etc/nix"
            "/etc/static"
            "/nix"
            "/:/host"
            "/tmp/.X11-unix"
            "/etc/inputrc"
            "/etc/resolv.conf"
            "${mkEtcHosts hostname}:/etc/hosts"
            "${mkEtcHostname hostname}:/etc/hostname"
            "${proxy-env}:/etc/profile.d/proxy-env.sh"
            "${display-env}:/etc/profile.d/display-env.sh"
            "${conda-env}:/etc/profile.d/conda-env.sh"
            "${home-manager-PATH-env}:/etc/profile.d/home-manager-PATH-env.sh"
            "${TERM-env}:/etc/profile.d/TERM-env.sh"
            "/run/opengl-driver/lib:${opengl-driver-bindpath}"
            # ssh
            "/etc/ssh/authorized_keys.d:/etc/ssh/authorized_keys.d:rootidmap"
          ] ++ [  # ssh
            "${tmpfiles-create-var-empty-directory}:/etc/tmpfiles.d/create-var-empty-directory.conf"
            "${tmpfiles-create-var-lib-systemd-linger-gy}:/etc/tmpfiles.d/enable-lingering-gy.conf"
            # add a line to `/etc/ssh/sshd_config` inside the container:
            #   Include sshd_config.d/*
            "${sshd_config-overrides}:/etc/ssh/sshd_config.d/overrides.conf"
            "${mkSshdConfigPortOverride 1722}:/etc/ssh/sshd_config.d/port-override.conf"
          ];
        };
      };
    };
    services = {
      "systemd-nspawn@".serviceConfig = {
        DeviceAllow = [
          "char-drm rwx"
          "/dev/dri rw"
          "/dev/shm rw"
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
      # this machine is not using an NVIDIA GPU
      "systemd-nspawn@${hostname}" = {
        overrideStrategy = "asDropin";
        wantedBy = [ "machines.target" ];
      };
    };
  };
}