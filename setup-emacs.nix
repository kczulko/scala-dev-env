{
  stdenv,
  fetchgit,
  git,
  coreutils,
  globalProjectsDir,
  emacsConfigSha256
}:

stdenv.mkDerivation rec {

    name = "setup-emacs";

    buildInputs = [ git coreutils ];

    githubProjectName = "emacsd-config";

    EMACSD = "~/.emacs.d";
    EMACSD_CONFIG_PROJECT_ROOT = "${globalProjectsDir}/${githubProjectName}";
    
    src = fetchgit {
      url = "https://github.com/kczulko/${githubProjectName}";
      deepClone = true;
      sha256 = emacsConfigSha256;
      branchName = "master";
    };

    phases = [ "installPhase" ];
    
    setup-script-content = ''
      #!/usr/bin/env bash
      set -x

      mkdir -p ${EMACSD_CONFIG_PROJECT_ROOT}
      cp -r $src/. ${EMACSD_CONFIG_PROJECT_ROOT}
      cd ${EMACSD_CONFIG_PROJECT_ROOT}
      chmod -R +w .
      touch .git/config
      git remote add origin git@github.com:kczulko/${githubProjectName}.git || :
      git restore --staged .

      mkdir -p ${EMACSD}

      ln -sf ${EMACSD_CONFIG_PROJECT_ROOT}/init.el $EMACSD/init.el || :
      ln -sfn ${EMACSD_CONFIG_PROJECT_ROOT}/configs $EMACSD/configs || :
      ln -sfn ${EMACSD_CONFIG_PROJECT_ROOT}/my_snippets $EMACSD/my_snippets || :
    '';

    installPhase = ''
      touch $name             
      echo "${setup-script-content}" > $name
      mkdir -p $out/bin
      chmod +x $name
      mv $name $out/bin/$name
    '';

 }
