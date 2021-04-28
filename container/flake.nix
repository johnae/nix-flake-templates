{
  description = "Build a container";

  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-misc, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
      let
        pkgs = forAllSystems (system: import nixpkgs {
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
                echo store path: ${image.outPath}
              '';
            })
          ];
        });
        dockerArchive = forAllSystems (system: pkgs.${system}.callPackage ./image.nix {
          dockerRegistry = "flake-example/example";
          # dockerTag = "latest"; # without this the tag becomes the hash of the nix build
        });
        pushArchive = forAllSystems (system: pkgs.${system}.pushDockerArchive { image = dockerArchive.${system}; });
      in
        {
          defaultPackage = dockerArchive;
          packages = forAllSystems (system:
            {
              dockerImage = {
                image = dockerArchive.${system};
                push = pushArchive.${system};
              };
            });
          devShell = forAllSystems (system: import ./devshell.nix { pkgs = pkgs.${system}; });
        };
}
