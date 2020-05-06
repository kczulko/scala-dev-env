# HOWTO


By default for 0.9.0 metals version:

```bash
$ nix-channel update
$ nix-shell --pure https://github.com/kczulko/scala-dev-env/tarball/master
```

or with some other metals version

```bash
$ nix-shell --argstr metalsVersion "X.Y.Z" --pure https://github.com/kczulko/scala-dev-env/tarball/master
```

