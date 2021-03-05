## The template this flake was based on can be found here:
## https://github.com/johnae/nix-flake-templates/devsh
{
  description = "Devsh";

  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlay = final: prev: {
        mkDevShell = prev.callPackage final.mkSimpleShell { };
      };
      devShell = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlay inputs.nix-misc.overlay ];
            };
          in
          pkgs.callPackage ./devshell.nix { }
        );
    };
}
