{
  pkgs ? import <nixpkgs> {},
  metalsVersion ? "0.9.0",
  metalsSha256 ? "116q2jzqlmdhkqvjg31b9ib8w1k7rlr8gmjcr7z32idpn16hqg59",
  emacsConfigSha256 ? "13kp7d5d3z2wy6vdwpgbf776rhbfcwnhdqk4gxpln799rbgh468k",
  globalProjectsDir ? "/home/karol/projects"
}:

let

  emacs = pkgs.emacs26;

  metals = pkgs.callPackage ./metals.nix {
    stdenv = pkgs.stdenv;
    coursier = pkgs.coursier;
    jdk = pkgs.jdk;
    metalsPkg = pkgs.metals;
    inherit metalsVersion metalsSha256;
  };

  setup-emacs = pkgs.callPackage ./setup-emacs.nix {
    stdenv = pkgs.stdenv;
    fetchgit = pkgs.fetchgit;
    git = pkgs.git;
    coreutils = pkgs.coreutils;
    inherit globalProjectsDir emacsConfigSha256;
  };

in pkgs.mkShell rec {

  buildInputs = [
    metals
    emacs
    setup-emacs
    pkgs.less
    pkgs.which
    pkgs.coreutils
    pkgs.jdk
    pkgs.silver-searcher
    pkgs.multimarkdown
    pkgs.git
    pkgs.sbt
  ];

}
 
