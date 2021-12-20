## The template this flake was based on can be found here:
## https://github.com/johnae/nix-flake-templates/devshell
{
  description = "A simple devshell flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, devshell, nix-misc, flake-utils }:
    let
      genPkgs = system: import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlay
          nix-misc.overlay
        ];
      };
      forAllDefaultSystems = f: flake-utils.lib.eachDefaultSystem
        (system: f system (genPkgs system));
    in
      forAllDefaultSystems (system: pkgs:
        {
          devShell = pkgs.devshell.mkShell {
            imports = [
              (pkgs.devshell.importTOML ./devshell.toml)
            ];
          };
        }
      )
  ;
}
