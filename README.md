Flakes
======

Trouble Shooting
----------------

* In case of `~/.nix-profile` being a broken symlink (probably pointing to
  `/nix/var/nix/profiles/per-user/$USER/profile`), run:

  ```bash
  $ nix-env --switch-profile /nix/var/nix/profiles/per-user/gy/home-manager/home-path
  ```

  for only once, the symlink should be fixed by now.  To let the changes take effect, re-login
  current user.
* If switching to regular user as root using something like `su gy` receives `su` complaining:

  ```
  su: Authentication service cannot retrieve authentication info
  ```

  Check `/etc/shadow` for the user's line of entry, it may have misformated. Consult `man:shadow(5)`
  for the format specs.  To resolve this, set `users.mutableUsers` in `configuration.nix` to `true`,
  manually change the problematic user's password once, `/etc/shadow` should be fixed by now, and
  `users.mutableUsers` can be changed back.
* If a flake needs to be built but the flake contains git submodules, use the following command:

  ```bash
  $ nix build '.?submodules=1'
  ```

  > Reference: <https://github.com/NixOS/nix/pull/5434>
* For a package whose name contains dash (`-`, like `wl-clipboard`), [`substituteAllInPlace
  <file>`](https://nixos.org/manual/nixpkgs/stable/#fun-substituteAllInPlace) won't work.  A
  workaround is to perform string substitution manually in the install script with
  [`substituteInPlace`](https://nixos.org/manual/nixpkgs/stable/#fun-substituteInPlace):

  ```bash
  $ substituteInPlace $script --replace @wl-clipboard@ ${wl-clipboard}
  ```

  See [./packages/notification-scripts/default.nix](./packages/notification-scripts/default.nix) and
  [./packages/notification-scripts/src/screenshot-notify](./packages/notification-scripts/src/screenshot-notify)
  for a concrete example.
* Since network credentials are managed by `sops`, it is crucial that the secret key is present
  during boot.  For the raspberry pi config, after flashing the image into the sd card, the secret
  key for `sops` must also be copied to the sdcard (use `rsync -aAX` to preserve mode info).

  > The image can be built with `nix build .#nixosConfigurations.rpi.config.system.build.sdImage`.

* On a machine with tight memory budgets, the `/nix/store` in an live environment might not have
  sufficient space for a installation.  The path `/nix/.rw-store` should be of type `tmpfs` at this
  moment, remount it to gain more spaces:

  ```bash
  $ mount -oremount,size=100% /nix/.rw-store
  ```

  > See <https://gist.github.com/blurgyy/0d559e6bb9f20de46f61938539b9cd74> for an example.

* If installation process is killed due to OOM, enable zram in the live environment:

  ```bash
  $ modprobe zram
  $ echo lz4 >/sys/block/zram0/comp_algorithm
  $ echo 2G >/sys/block/zram0/disksize
  $ mkswap /dev/zram0
  $ swapon --priority 100 /dev/zram0
  ```

  > See <https://gist.github.com/blurgyy/0d559e6bb9f20de46f61938539b9cd74> for an example.

* If installation was successfull but boot fails at Stage 1, complaining that the root filesystem
  could not be found and mounted, this may be due to related kernel modules not being loaded.  On a
  bandwagon machine, adding an entry `virtio_scsi` to both `boot.initrd.availableKernelModules` and
  `boot.initrd.kernelModules` before installing solved this problem.

  **Edit**: Or, add `(modulesPath + "/profiles/qemu-guest.nix")` to the `imports` list.

  > See [./nixos/_parts/defaults/default.nix](./nixos/_parts/defaults/default.nix) for an concrete
  > example.
  > Related: <https://github.com/NixOS/nixpkgs/issues/76980>

* To boot from an ISO located on a physical drive `/dev/vda3` at path `/live.iso`, use below grub
  entry:
  ```
  menuentry "NixOS minimal ISO" --class nixos {
    set isofile="/live.iso"
    set linux_path="/boot/bzImage"
    set initrd_path="/boot/initrd"
    loopback loop (hd0,3)$isofile  # /dev/vda3
    linux (loop)$linux_path init=/nix/store/69d87r2dvhhbbq17lsw04msvcq0y0kg0-nixos-system-nixos-22.05.2676.b9fd420fa53/init root=LABEL=nixos-minimal-22.05-x86_64 boot.shell_on_fail loglevel=4 copytoram
    initrd (loop)$initrd_path
  }
  ```

  > **Note that the kernel params are copied from inside the ISO image**.

* If the live environment cannot pass through stage 1 due to `/dev/root` not appearing, a workaround
  is to copy all contents of the ISO image to a standalong partition and use it as the `root=`
  parameter, e.g.
  ```bash
  $ mkdir iso-mnt fresh-part-mnt
  $ mount /live.iso iso-mnt/
  $ mount /dev/disk/by-label/fresh-partition fresh-part-mnt/
  $ cp -vr iso-mnt/* fresh-part-mnt/
  ```
  And The `linux (loop)$linux_path ...` line in the above menuentry becomes:
  ```
    linux (loop)$linux_path init=/nix/store/69d87r2dvhhbbq17lsw04msvcq0y0kg0-nixos-system-nixos-22.05.2676.b9fd420fa53/init root=LABEL=nixos-minimal-22.05-x86_64 boot.shell_on_fail loglevel=4 copytoram
  ```
  Where the `/dev/disk/by-label/fresh-partition` should be the partition to create and put all
  contents in.

* In case bootloader was installed when a wrong partition (or no partition) was mounted on `/boot`,
  reinstall bootloader with:
  ```bash
  $ sudo NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot
  ```
