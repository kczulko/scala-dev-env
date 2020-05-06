{
  pkgs ? import <nixpkgs> {},
  metalsVersion ? "0.9.0",
  metalsSha256 ? "116q2jzqlmdhkqvjg31b9ib8w1k7rlr8gmjcr7z32idpn16hqg59"
}:

let

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
    
    src = pkgs.fetchgit {
      url = "https://github.com/kczulko/emacsd-config";
      # owner = "kczulko";
      # repo = "emacsd-config";
      # rev = "master";
      deepClone = true;
      sha256 = "13kp7d5d3z2wy6vdwpgbf776rhbfcwnhdqk4gxpln799rbgh468k";
      branchName = "master";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      # mkdir -p ~/.emacsd2
      # mv $src ~/.emacsd2/
      chmod -R +w $src
      mkdir -p $out
      cp -r $src $out
    '';
      
  };

in pkgs.mkShell rec {
  
  buildInputs = [
    metals
    emacsd-config
    pkgs.jdk
    pkgs.silver-searcher
    pkgs.multimarkdown
    pkgs.emacs26
    pkgs.git
  ];

  shellHook = ''
     alias emcs='emacs -q --load ${emacsd-config.src}/init.el'
  '';

  EMACS_USER_DIRECTORY=emacsd-config.src;
  EMACSD_CONFIG=emacsd-config.src;
}
