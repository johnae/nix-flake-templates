{
  description = "Flake for building container images";

  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-misc, ... }:
    let
      ## NOTE: you can build archives for say x86_64-darwin but they won't work anywhere
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      genAttrs' = values: f: builtins.listToAttrs (map f values);
    in
      let
        pkgset = forAllSystems (system: import nixpkgs {
          localSystem = { inherit system; };
          overlays = [
            nix-misc.overlay
            (final: prev: {
              pushDockerArchive = { image, tag ? null }:
                let
                  imageTag = if tag != null then tag else
                    builtins.head (prev.lib.splitString "-" (builtins.baseNameOf image.outPath));
                in
                prev.writeStrictShellScript "pushDockerArchive" ''
                echo pushing ${image.imageName}:${imageTag} 1>&2
                ${prev.skopeo}/bin/skopeo copy "$@" \
                  docker-archive:${image} \
                  docker://${image.imageName}:${imageTag} 1>&2
                echo pushed to: ${image.imageName}:${imageTag} 1>&2
                echo ${image.outPath}
              '';
            })
          ];
        });
        containerImageArchives = forAllSystems (system:
          let
            pkgs = pkgset.${system};
            imageDir = ./images;
            genFullPath = name: imageDir + "/${name}";
            imagePaths = map genFullPath (builtins.attrNames (builtins.readDir imageDir));
          in
            genAttrs' imagePaths (path: {
              name = (pkgs.lib.removeSuffix ".nix" (builtins.baseNameOf path));
              value = pkgs.callPackage path {
                    dockerRegistry = "flake-example";
                    # dockerTag = "latest"; # without specifying this the tag is the hash of the derivation which is usually what you want
                  };
            }));

        containerImagePushScripts = forAllSystems (system:
          let
            pkgs = pkgset.${system};
          in
            pkgs.lib.mapAttrs' (name: value: pkgs.lib.nameValuePair ("${name}-push") (pkgs.pushDockerArchive { image = value; }))
              containerImageArchives.${system});

        packages = forAllSystems (system:
          containerImageArchives.${system} // containerImagePushScripts.${system}
        );
      in
        {
          inherit packages;
          devShell = forAllSystems (system: import ./devshell.nix { pkgs = pkgset.${system}; });
        };
}
