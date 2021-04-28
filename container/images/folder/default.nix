{ stdenv
, lib
, writeStrictShellScriptBin
, coreutils
, bashInteractive
, dockerTools
, dockerRegistry ? "example"
, dockerTag ? "latest"
}:
let

  entrypoint = writeStrictShellScriptBin "entrypoint.sh" ''
    export PATH=${coreutils}/bin:${PATH:+:}$PATH
    echo hello
    sleep 5
    echo Check config file
    cat /etc/folderconf.yaml
    echo bye
  '';
in
dockerTools.buildLayeredImage {
  name = "${dockerRegistry}/test";
  tag = dockerTag;
  contents = [
    ./rootfs
    bashInteractive
    coreutils
  ];

  config = {
    Entrypoint = [ "${entrypoint}/bin/entrypoint.sh" ];
    WorkingDir = "/";
    Volumes = {
      "/var/lib/myvol" = { };
    };
  };
}
