# What is it

This project automates [github.com/kczulko/emacs-config](github.com/kczulko/emacs-config) installation and created scala development environment through nix-shell.

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
  $ nix-shell --pure --command "setup-emacs && emacs" https://github.com/kczulko/scala-dev-env/tarball/master
  ```

There are several parameters to pass (all are set to defaults):

1. _metalsVersion_ : version of metals to install
1. _metalsSha256_  : metals sha256
1. _emacsConfigSha256_ : sha256 of [github.com/kczulko/emacs-config](github.com/kczulko/emacs-config)
1. _globalProjectsDir_ : directory under which emacs-config repository will be clonned. Default to `/home/karol/projects`

Based on that finall call may look more less like that:

  ```bash
  $ nix-shell --pure --argstr metalsVersion "1.0.0" --command "setup-emacs && emacs" https://github.com/kczulko/scala-dev-env/tarball/master  
  ```

