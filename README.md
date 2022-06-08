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
