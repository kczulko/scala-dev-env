{ stdenv, coursier, jdk, metalsPkg, metalsVersion, metalsSha256 }:

metalsPkg.overrideAttrs (oldAttrs: rec {

  version = metalsVersion;

  name = "${baseName}-${version}";
  
  baseName = "metals";

  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} \
         -r bintray:scalacenter/releases \
         -r sonatype:snapshots > deps
         mkdir -p $out/share/java
         cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = metalsSha256;
  };

  buildInputs = [ jdk deps ];

})
