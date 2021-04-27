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
          overlays = [ nix-misc.overlay ];
        });
      in
        {
          defaultPackage = forAllSystems (system: pkgs.${system}.callPackage ./image.nix { });
          devShell = forAllSystems (system: import ./devshell.nix { pkgs = pkgs.${system}; });
        };
}
