# HOWTO


1. Install nix

  ```bash
  $ curl -L https://nixos.org/nix/install | sh
  ```
1. Update nix-channel

  ```bash
  $ nix-channel update
  ```

1. Execute (for default metals version)

  ```bash
  $ nix-shell --pure https://github.com/kczulko/scala-dev-env/tarball/master
  ```

or with some other metals version

  ```bash
  $ nix-shell --argstr metalsVersion "X.Y.Z" --pure https://github.com/kczulko/scala-dev-env/tarball/master
  ```

