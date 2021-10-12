## The template this flake was based on can be found here:
## https://github.com/johnae/nix-flake-templates/shell
{
  description = "Simple Devshell";

  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-misc, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShell = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ nix-misc.overlay ];
            };
          in
            pkgs.callPackage ./devshell.nix {
              mkDevShell = pkgs.callPackage nix-misc.lib.mkSimpleShell {};
            }
        );
    };
}
