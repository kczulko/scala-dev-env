{
  pkgs ? import <nixpkgs> {},
  metalsVersion ? "0.9.0",
  metalsSha256 ? "116q2jzqlmdhkqvjg31b9ib8w1k7rlr8gmjcr7z32idpn16hqg59"
}:

let

  emacs = pkgs.emacs26;

  metals = pkgs.metals.overrideAttrs (oldAttrs: rec {

    version = metalsVersion;

    baseName = "metals";

    deps = pkgs.stdenv.mkDerivation {
      name = "${baseName}-deps-${version}";
      buildCommand = ''
        export COURSIER_CACHE=$(pwd)
        ${pkgs.coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} \
           -r bintray:scalacenter/releases \
           -r sonatype:snapshots > deps
           mkdir -p $out/share/java
           cp -n $(< deps) $out/share/java/
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash     = metalsSha256;
    };

    name = "${baseName}-${version}";

    buildInputs = [ pkgs.jdk deps ];
  });

  emacsd-config = pkgs.stdenv.mkDerivation {
    name = "kczulko-emacsd-config";

    buildInputs = [ emacs ];

    src = pkgs.fetchgit {
      url = "https://github.com/kczulko/emacsd-config";
      deepClone = true;
      sha256 = "13kp7d5d3z2wy6vdwpgbf776rhbfcwnhdqk4gxpln799rbgh468k";
      branchName = "master";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      chmod -R +w $src
      ln -sf $src $out/src
    '';
      
  };

in pkgs.mkShell rec {
  
  buildInputs = [
    metals
    emacs
    emacsd-config
    pkgs.less
    pkgs.which
    pkgs.coreutils
    pkgs.jdk
    pkgs.silver-searcher
    pkgs.multimarkdown
    pkgs.git
  ];

  shellHook = ''
    alias emacss='emacs -q --load "${emacsd-config.src}/init.el"'
  '';

  EMACSD_CONFIG=emacsd-config.src;
}
