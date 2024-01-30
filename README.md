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
  sufficient space for an installation.  The path `/nix/.rw-store` should be of type `tmpfs` at this
  moment, remount it to gain more space:

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

* If installation was successful but boot fails at Stage 1, complaining that the root filesystem
  could not be found and mounted, this may be due to related kernel modules not being loaded.  On a
  bandwagon machine, adding an entry `virtio_scsi` to both `boot.initrd.availableKernelModules` and
  `boot.initrd.kernelModules` before installing solved this problem.

  **Edit**: Or, add `(modulesPath + "/profiles/qemu-guest.nix")` to the `imports` list.

  > See [./nixos/_parts/defaults/default.nix](./nixos/_parts/defaults/default.nix) for an concrete
  > example.
  > Related: <https://github.com/NixOS/nixpkgs/issues/76980>

* To boot from an ISO located on a physical drive `/dev/vda3` at path `/live.iso`, use below grub
  entry (on Arch, add this content to `/etc/grub.d/40_custom`):
  ```
  menuentry "NixOS minimal ISO" --class nixos {
    set isofile="/live.iso"
    set linux_path="/boot/bzImage"
    set initrd_path="/boot/initrd"
    loopback loop (hd0,3)$isofile  # /dev/vda3
    linux (loop)$linux_path init=/nix/store/69d87r2dvhhbbq17lsw04msvcq0y0kg0-nixos-system-nixos-22.05.2676.b9fd420fa53/init root=LABEL=nixos-minimal-22.05-x86_64 boot.shell_on_fail loglevel=4 copytoram
    initrd (loop)$initrd_path
  }
  menuentry "NixOS minimal ISO" --class nixos {
    set isofile="/live.iso"
    set linux_path="/boot/bzImage"
    set initrd_path="/boot/initrd"
    loopback loop (hd0,3)$isofile  # /dev/vda3
    linux (loop)$linux_path findiso=(hd0,3)$isofile init=/nix/store/39ajmfiwqsxmjlql9k8bm998d47cb4y3-nixos-system-installer-22.11.20220909.cc6ef94/init root=LABEL=isoroot boot.shell_on_fail net.ifnames=0 ip=154.9.139.26::154.9.139.1:255.255.255.0::eth0:dhcp loglevel=4 copytoram
    initrd (loop)$initrd_path
  }
  ```

  > **Note that the kernel params are copied from inside the ISO image**.

* If the live environment cannot boot through stage 1 due to `/dev/root` not appearing, a workaround
  is to copy all contents of the ISO image to a standalone partition and use it as the `root=`
  parameter, e.g.
  ```bash
  $ mkdir iso-mnt fresh-part-mnt
  $ mount /live.iso iso-mnt/
  $ mount /dev/disk/by-label/fresh-partition fresh-part-mnt/
  $ cp -vr iso-mnt/* fresh-part-mnt/
  ```
  And The `linux (loop)$linux_path ...` line in the above menuentry becomes:
  ```
    linux (loop)$linux_path init=/nix/store/69d87r2dvhhbbq17lsw04msvcq0y0kg0-nixos-system-nixos-22.05.2676.b9fd420fa53/init root=LABEL=fresh-partition boot.shell_on_fail loglevel=4 copytoram
  ```
  Where the `/dev/disk/by-label/fresh-partition` should be the partition to create and put all
  contents in.
  * If creating a standalone partition is not possible (e.g. because the virtual machine's initial
    partition table did not leave sufficient amount of space, and online-shrink of ext4 filesystems
    is not possible), copy the files inside the iso to the current partition (i.e. the one mounted
    at `/` in the running system) also works.  Remember to replace the `root=` kernel parameter
    before running `grub-mkconfig -o /boot/grub/grub.cfg`, then reboot.

* In case bootloader was installed when a wrong partition (or no partition) was mounted on `/boot`,
  reinstall bootloader with:
  ```bash
  $ sudo NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot
  ```

* If hydra jobset evaluation fails and shows only "evaluation failed with exit code 255" on the web
  frontend, it may be caused by changing jobset/project name earlier.  Log into the hydra machine
  and confirm this with `journalctl -eu hydra-evaluator`, journal will contain a line like

  ```log
  /nix/store/n1hh77ld9bl8rawad1y68sfy9jsrc6ml-hydra-2022-08-08/bin/.hydra-eval-jobset-wrapped: evaluation of jobset ‘configs:all (jobset#4)’ failed with exit code 255
  ```

  Restart `hydra-evaluator.service` fixed this issue.

* Adding a `netboot.xyz` entry to GRUB:
  - Download the `.lkrn` file:
    ```bash
    $ curl -L https://boot.netboot.xyz/ipxe/netboot.xyz.lkrn -o /netboot.xyz.lkrn
    ```
  - Add below entry to `/etc/grub.d/40_custom`:
    ```
    menuentry "netboot.xyz.lkrn" {
        linux16 (hd0,2)/netboot.xyz.lkrn  # /dev/*da2
    }
    ```
  - Remove the line `GRUB_TIMEOUT_STYLE=hidden` from `/etc/default/grub` if any, change
    `GRUB_TIMEOUT` in this file to a larger value to allow interaction with the grub menu:
    ```conf
    # GRUB_TIMEOUT_STYLE=hidden
    GRUB_TIMEOUT=10
    ```
  - Update GRUB config:
    ```bash
    $ grub-mkconfig -o /boot/grub/grub.cfg
    ```
  - If for some reason the grub menu is not desired to be interacted, look into the generated
    `boot/grub/grub.cfg` file, count the index of the netboot entry (0-indexed), set `GRUB_DEFAULT`
    to this index in `/etc/default/grub`:
    ```conf
    # partial content in /etc/default/grub
    GRUB_DEFAULT=2  # 0-indexed, this will automatically choose the 3rd entry in the grub menu
    ```
    then regenerate GRUB config:
    ```bash
    $ grub-mkconfig -o /boot/grub/grub.cfg
    ```
  - Reboot:
    ```
    $ reboot
    ```
  - Example network config:
    ```
    Set network interface number: 0
    IP:203.0.113.2
    Subnet mask:255.255.255.0
    Gateway:203.0.113.1
    DNS:8.8.8.8
    ```

  > Reference: <https://gist.github.com/AndersonIncorp/9fb7402cf69a0994e175ebec8194847c>

* Installing NixOS from Alpine
  * Flush IPv6 address if DNS resolves to IPv6 address and network fails:
    ```bash
    $ ip -6 addr flush eth0  # change interface name to the one in the output of `ip a`
    ```
    If the IPv6 address come back after one network connection, just run this command in an infinite
    loop in a tty, and run other commands in another tty.
  * To add package repositories for `nix` and its dependency `libcpuid`, add below two lines to
    `/etc/apk/repositories`:
    ```txt
    http://dl-cdn.alpinelinux.org/alpine/edge/testing
    http://dl-cdn.alpinelinux.org/alpine/edge/community
    ```
    Then run `apk update`.
  * Install `bash` for vi mode and the later `nix shell` call:
    ```bash
    $ apk add bash
    $ exec bash
    $ set -o vi  # vi keybindins in bash
    ```
  * [optional] Install `openssh` and setup public keys for installing via ssh:
    ```bash
    $ apk add openssh
    $ service sshd start
    $ apk add curl
    $ mkdir -p ~/.ssh
    $ curl https://github.com/blurgyy.keys >>.ssh/authorized_keys
    ```
  * Install `util-linux` and `btrfs-progs` for disk partitioning:
    ```bash
    $ apk add util-linux btrfs-progs
    ```
  * Partition disks, add a `/nix` subvolume for mounting on the live system to avoid disk out of
    spasce error later:
    ```bash
    $ fdisk /dev/vda  # vda for example
      [...]
    $ mkfs.btrfs /dev/vda2 -L nixos-root  # --force
    $ mkfs.vfat /dev/vda3 -n nixos-boot

    $ mount -ocompress-force=zstd:3 /dev/vda2 /mnt
    $ mkdir /mnt/boot
    $ mount /dev/disk/by-label/nixos-boot /mnt/boot

    $ btrfs subvolume create /mnt/nix
    $ mkdir -p /nix
    $ mount -osubvol=nix,compress-force=zstd:3 /dev/vda2 /nix
    $ # or: mount -obind /mnt/nix /nix

    $ btrfs subvolume create /mnt/tmp
    $ mount -osubvol=tmp,compress-force=zstd:3 /dev/vda2 /tmp
    $ # or: mount -obind /mnt/tmp /tmp
    ```
  * With `/mnt/nix` being binded to `/nix`, add `nix` from apk and start nix-daemon:
    ```bash
    $ apk add nix
    $ service nix-daemon start  # with nix 2.19.2, this seems necessary
    ```
  * Copy contents to `/etc/nix/nix.conf`:
    ```conf
    allowed-users = *
    auto-optimise-store = true
    builders = 
    cores = 0
    experimental-features = nix-command flakes repl-flake
    #extra-platforms = aarch64-linux i686-linux i686-linux
    max-jobs = auto
    narinfo-cache-negative-ttl = 30
    require-sigs = true
    sandbox = true
    sandbox-fallback = false
    substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://nixos-cn.cachix.org https://nix-community.cachix.org https://cache.blurgy.xyz https://cache.nixos.org/
    system-features = nixos-test benchmark big-parallel kvm
    tarball-ttl = 30
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.blurgy.xyz:Xg9PvXkUIAhDIsdn/NOUUFo+HHc8htSiGj7O6fUj/W4=
    trusted-substituters = 
    trusted-users = root
    ```
  * Install utilities for installation via nix:
    ```bash
    $ nix shell nixpkgs#{nixStable,nixos-install-tools}  # use nix from nixpkgs instead from apline's channel
    ```
  * Install NixOS:
    ```bash
    $ nixos-install --flake gitlab:highsunz/flames#<HOSTNAME>
    ```
  * Last but very importantly, **Copy secrets to the host** and place it at its proper location.
  * Reboot.

* If after partitioning, no partition under `/dev` is shown, only the disk itself appears under
  `/dev`, use `mknod`.  Usage of `mknod` is `mknod [OPTION]... NAME TYPE [MAJOR MINOR]`.  We will
  create a block device by specifying `b` as TYPE, the MAJOR and MINOR can be read from
  `/proc/partitions`,  e.g.:
  ```bash
  $ cat /proc/partitions
    major minor  #blocks  name

       8        0 3907018584 sda
       8        1 3907017543 sda1
     259        0  488386584 nvme0n1
     259        1     102400 nvme0n1p1
     259        2      16384 nvme0n1p2
     259        3  182573029 nvme0n1p3
     259        4   16777216 nvme0n1p4
     259        5     512000 nvme0n1p5
     259        6  288404487 nvme0n1p6
     254        0   32487424 zram0
  $ mknod /dev/nvme0n1p4 b 259 4
  ```

  > Reference: <https://superuser.com/questions/120905/fdisk-l-shows-a-partition-is-not-in-dev-directory>

* On non-nixos machines, do not install `gcc` or `python` with home-manager, as they silently cause
  problems during compiling (default C compiler is set to `~/.nix-profile/bin/cc` by cmake) and
  package installing (pacman installs system-level python packages like `python-catkin_pkg` to
  somewhere like
  `/nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-python3-3.10.6-env/lib/python3.10/site-packages/`).

* In case the local nix store is corrupted, the corrupted path can be found via 
  ```bash
  $ nix store verify --all
  ```
  Then the found corrupted path can be repaired with
  ```bash
  $ sudo nix store repair /nix/store/<hash>-<name>
  ```
  > **Warning**
  > 
  > Consult the "Description" section of `nix store repair --help` for caveats of this approach.

* To run GUI programs inside systemd-nspawn containers, a simple way is to:
  1. Bind-mount (read-only) `/tmp/.X11-unix` from host to the container
  2. Set `DISPLAY` variable inside container to the same as from the host
  3. In a terminal that can run GUI application in the host machine, run
    ```bash
    $ xhost +local:
    ```
  Though `xhost` [is considered
  dangerous](https://stackoverflow.com/questions/63884968/why-is-xhost-considered-dangerous), the
  above procedure does get the job done.

* While installing WSL2 dependencies on Windows 11 using `wsl --install --no-distribution` inside a
  powershell, it may fail with a network error.  Run the following powershell commands to use the
  system's proxy:
  ```powershell
  $browser = New-Object System.Net.WebClient
  $browser.Proxy.Credentials =[System.Net.CredentialCache]::DefaultNetworkCredentials
  ```
  > Reference: <https://stackoverflow.com/questions/14263359/access-web-using-powershell-and-proxy>

* To add the system's secret key to the tarball created by
  [nixos-wsl](https://github.com/nix-community/nixos-wsl), first decompress the gzipped tarball, and
  append the file to it, e.g.:
  ```bash
  $ gunzip -c result/tarball/nixos-wsl-installer.tar.gz >decompressed.tar
  $
  $ # the secret is typically put at /var/lib/<hostname>.age
  $ tar --append --file=decompressed.tar --transform='s:^:var/lib/:' hostname.age
  $
  $ # inspect the modified tarball
  $ tar --list --file=decompressed.tar
  ```

* WSL2 imposes resources constraints on processes from it, to build on another machine with hostname
  `<host>` that we have SSH access, append `--store ssh-ng://<host>` to nix3 commands, e.g.:
  ```bash
  $ nix build .#devShells.x86_64-linux.cudaDevShell --impure --store ssh-ng://morty
  ```
  > Reference: <https://docs.nixbuild.net/remote-builds/#using-remote-stores>
  >
  > **Note**: while using `nix develop`, the command should also be `nix build` to allow copying
  > over network later.

* After building closures on a remote store, the closures need to be copied from it.  If `nix copy`
  fails with an error:
  ```bash
  $ nix copy --from ssh-ng://morty (nix path-info .#cudaDevShell --impure --json | jq -r '.[].path')
  error: cannot add path '/nix/store/g15j0y3fzvx4kkry4viymn698m1gk8yx-cudatoolkit-11.7.0' because it lacks a signature by a trusted key
  ```
  To temporarily workaround this, use the `--no-check-sigs` flag:
  ```bash
  $ nix copy --from ssh-ng://morty (nix path-info .#cudaDevShell --impure --json | jq -r '.[].path') --no-check-sigs
  ```
  > Reference: <https://github.com/NixOS/nix/issues/4894#issuecomment-1252510474>

* In case the nix database (at `/nix/var/nix/db/db.sqlite`) is corrupted (probably due to performing
  an operation while the disk is full):
  1. Stop nix-daemon:
    ```bash
    $ systemctl --system stop nix-daemon{,.socket}
    ```
  2. Backup the database:
    ```bash
    $ sudo sqlite3 /nix/var/nix/db/db.sqlite ".backup '/tmp/bak.sqlite'"
    ```
  3. Create a textual dump of the database for restoring:
    ```bash
    $ sudo sqlite3 /nix/var/nix/db/db.sqlite .dump >/tmp/textual.sql
    $
    $ # inspect the dumped sql, size of this file should be ~100M
    $ less /tmp/textual.sql
    ```
  4. If last line of this file is `ROLLBACK;`, change it to `COMMIT` or we won't restor anything
  5. Restore the database by applying the textual sql commands to a newly created database:
    ```bash
    $ sqlite3 /tmp/new.sqlite </tmp/textual.sql
    ```
  6. Make sure the backup from step 2 is the same as current database:
    ```bash
    $ diff /tmp/bak.sqlite /nix/var/nix/db/db.sqlite  # should output nothing
    ```
  7. Move the restored database to the location:
    ```bash
    $ sudo mv /tmp/new.sqlite /nix/var/nix/db/db.sqlite
    ```
  8. Restart nix-daemon.

  > Reference: <https://github.com/NixOS/nix/issues/1353>

* Enabling webcam on Raspberry Pi 4B
  TL;DR: add two lines to the `config.txt` file which is located **in the firmware partition**:
  ```
  start_x=1
  gpu_mem=256
  ```
  The firmware partition is typically the first partition of type `vfat`, in my case it's
  `/dev/mmcblk0p1`.  Note that it's probably NOT mounted at `/boot` (but rpi still respects its
  content).

  > References:
  >   - <https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi#Camera>
  >   - <https://github.com/NixOS/nixpkgs/issues/173948#issuecomment-1718069205>
  >   - <https://www.raspberrypi.com/documentation/computers/config_txt.html#start_x-start_debug>
  >   - <https://www.raspberrypi.com/documentation/computers/config_txt.html#gpu_mem>

* To show current total GPU memory, use `sudo vcgencmd get_mem gpu`, where `vcgencmd` is from
  package `libraspberrypi`.

* Tailscale's [MagicDNS](https://tailscale.com/kb/1081/magicdns/) returns SERVFAIL for any
  unrecognized domain, only domains that starts with a configured hostname in [Tailscale's admin
  panel](https://login.tailscale.com/admin/machines) and end with the configured tailnet name (by
  default it has the form `.tailXXXXX.ts.net`).

* On WSL2, if directly opening a terminal in a Windows Terminal (`wt`) tab, using `systemctl --user`
  for user-scope service management might give an error:

    Failed to connect to bus: No such file or directory.

  In this case, run:

  ```bash
  $ systemctl --system restart user@1000.service  # assume the user's id is 1000
  ```

* Computing the hash of a file given its download url:

  ```bash
  $ nix hash to-sri sha256:$(nix-prefetch-url https://..... --type sha256)
  ```

  > Reference: <https://github.com/NixOS/nixpkgs/issues/191128#issuecomment-1246030466>

* To update packages except `foo` and `bar`, use a combination of `tomlq` (from `nixpkgs#yq`) and
  `jq` to create a regular expression from [`nvfetcher.toml`](./packages/nvfetcher.toml):

  ```bash
  $ tomlq keys nvfetcher.toml | jq -r 'map(select(test("foo|bar") | not)) | join("|")'
  ```

  It can then be passed to the `--filter` option of `nvfetcher`:

  ```bash
  $ nvfetcher --filter "'$(tomlq keys nvfetcher.toml | jq -r 'map(select(test("alcn|tdesktop-megumifox") | not)) | join("|")')'" -k ~/.config/nvchecker/keyfile.toml --commit-changes -v
  ```

* Mapping a keyboard to another layout using `xkbcomp` and `ckbcomp`:

  `ckbcomp` expects a file containing only a xkb_symbols section.  Such a file can be obtained
  by the below steps:
    1. use `xkbcomp $DISPLAY output.xkb` to get a file `output.xkb`, the `output.xkb` file will
       contain an outer section named "xkb_keymap", inside it there should be several sections,
       includgin "xkb_keycodes", "xkb_types", "xkb_compatibility", and "xkb_symbols".
    2. retain only the "xkb_symbols" inner section, and remove the outer "xkb_keymap" braces.
    3. the file structure should now look like ${./keymap.xkb}.
  * To customize the keymap, search for the respective keys and swap/ovewrite their rvalues.
  * Modifiers probably should be specified using modifier_map located at the end of the
    xkb_symbols section.

* Inspect current sending queue on a postfix mail server:
  ```bash
  $ sudo postqueue -j  # output as json
  ```
  Delete an item from the queue:
  ```bash
  $ sudo postsuper -d 0628818AB791  # replace 0628818AB791 with value of the "queue_id" field in the previous command
  ```

* Mail server cannot receive mail, the mail server does not log anything when sending an mail from
  an external address (e.g. gmail.com) to the mail server:
  The DNS record may be malconfigured.  Make sure the mail address (the part after the `@` character
  of the mail address that should receive emails) on cloudflare's DNS dashboard is set to "DNS only"
  (as opposed to "Proxied").
  It seems that the smtp address (e.g. `smtp.blurgy.xyz`) can be set to "Proxied" though.

* Cannot fetch mails via IMAP from the mail server:
  The DNS record may be malconfigured.  Make sure the imap mail address (e.g. `imap.blurgy.xyz`) on
  cloudflare's DNS dashboard is set to "DNS only" (as opposed to "Proxied").

* Logseq (or any electron-based apps?) opens up with an empty window:
  Delete its GPU cache directory and relaunch:
  ```bash
  $ rm -r ~/.config/Logseq/GPUCache
  ```

  Reference: <https://github.com/microsoft/vscode/issues/195502#issuecomment-1761143787>

* To change user ID from 1001 to 1000 on a ubuntu machine (if the user with ID 1000 is already
  deleted):
  1. Change the user's ID from 1001 to 1000 in `/etc/passwd`, `/etc/group`, and `/etc/shadow` (last
     time I checked, `/etc/shadow` did not need modify, because it did not contain any occurences of
     the string "1001")
  2. Change file ownership:
     ```bash
     $ find /home -uid 1001 -exec chown -h 1000 {} +
     ```
     Idealy, only files under the user's HOME directory should be owned by the user, so above
     command only finds files under `/home`.

  Reference: <https://askubuntu.com/a/16719>

* To update conda to latest version, with no conda environment activated run:
  ```bash
  $ conda --version
  # this should output the old version
  $ conda update -n base -c defaults -c conda-forge conda
  $ conda --version
  # this should output the latest version
  ```
