{ config, pkgs, ... }:

# NOTE: qemu is overlayed to use version from nixpkgs stable release

let
  VMName = "wisp";

  VMDiskDirectory = "/var/lib/libvirt/images";
  VMDiskFilename = "${VMName}.qcow2";

  VMDiskPath = "${VMDiskDirectory}/${VMDiskFilename}";

  VMDiskSize = "64G";
  VMRAMMB = 8192;
  VMCPUCores = 4;

  VMRDPPort = 3389;
in

{
  sops.secrets."sshrp/${VMName}-rdp" = {};
  sops.secrets."sshrp/${VMName}-vnc" = {};

  environment.systemPackages = [
    pkgs.qemu
  ];

  # enable and configure the libvirt daemon
  virtualisation.libvirtd.enable = true;

  # define a systemd service to create a VM disk (if it does not exist)
  systemd.services = {
    "create-disk-for-${VMName}" = {
      wantedBy = [ "spin-up-${VMName}.service" ];
      before = [ "spin-up-${VMName}.service" ];
      path = [
        pkgs.qemu
      ];
      script = ''
        if [ ! -f ${VMDiskPath} ]; then
          mkdir -p ${VMDiskDirectory}
          qemu-img create -f qcow2 ${VMDiskPath} ${VMDiskSize}
        fi
      '';
    };

    "spin-up-${VMName}" = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "create-disk-for-${VMName}.service" ];
      path = [ pkgs.qemu ];
      script = ''
        qemu-system-x86_64 \
          -enable-kvm \
          -m ${toString VMRAMMB} \
          -cpu host \
          -smp cores=${toString VMCPUCores} \
          -drive file=${VMDiskPath},format=qcow2 \
          -drive file=${pkgs.fedora-virtio-win-iso},index=3,media=cdrom \
          -vnc :0 \
          -netdev user,id=usernet,hostfwd=tcp:127.0.0.1:${toString VMRDPPort}-:3389 \
          -device e1000,netdev=usernet
      '';
    };
  };

  services.ssh-reverse-proxy = {
    client.instances = {
      "${VMName}-rdp" = {
        environmentFile = config.sops.secrets."sshrp/${VMName}-rdp".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = VMRDPPort;
        hostPort = VMRDPPort;
      };
      "${VMName}-vnc" = {
        environmentFile = config.sops.secrets."sshrp/${VMName}-vnc".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 5900;
        hostPort = 5900;
      };
    };
  };
}
