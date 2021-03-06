# What is it

This project automates [github.com/kczulko/emacs-config](github.com/kczulko/emacs-config) installation and creates scala development environment through nix-shell.

# HOWTO

1. Install nix
  ```bash
  $ curl -L https://nixos.org/nix/install | sh
  ```
2. Update nix-channel
  ```bash
  $ nix-channel update
  ```

3. Execute (for default metals version)
  ```bash
  $ nix-shell --pure \
    --arg addEmacs true \
    --command "setup-emacs && emacs" \
    https://github.com/kczulko/scala-dev-env/tarball/master
  ```

There are several parameters to pass (all are set to defaults):

1. _metalsVersion_ : version of metals to install
1. _addEmacs_ : default _false_, adds or removes emacs, its deps, and setup script from shell
1. _metalsSha256_  : metals sha256
1. _emacsConfigSha256_ : sha256 of [github.com/kczulko/emacs-config](github.com/kczulko/emacs-config)
1. _globalProjectsDir_ : directory under which emacs-config repository will be cloned. Default to `/home/karol/projects`

Based on that finall call may look more less like that:

  ```bash
  $nix-shell --pure \
    --arg addEmacs true \
    --argstr metalsVersion "0.9.4" \
    --argstr metalsSha256 "1k07gg13z3kambvvrxsc27781cd5npb2a50ahdbj7x6j6h67k0pg"
    --argstr globalProjectsDir "/home/kczulko/Projects"
    --command "setup-emacs && emacs"
    https://github.com/kczulko/scala-dev-env/tarball/master
  ```

