{
  description = "Some Rust application";

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, fenix, nixpkgs, ... }:
    let
      #package = pkgs: {
      #  pname = "my-app";
      #  version = "v0.0.0";
      #  src = self;
      #  cargoSha256 = "sha256-0000000000000000000000000000000000000000";
      #  doCheck = false;
      #  nativeBuildInputs = [ pkgs.pkgconfig ];
      #  buildInputs = [ ];
      #  meta = {
      #    license = pkgs.stdenv.lib.licenses.mit;
      #    maintainers = [
      #      {
      #        email = "me@myself.org";
      #        github = "me";
      #        name = "Me Me Me";
      #      }
      #    ];
      #  };
      #};
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
      #{
      #  overlay = final: prev: {
      #    my-app = prev.rustPlatform.buildRustPackage (package prev);
      #  }
      #} //
      forAllSystems (system:
        let
          pkgs = import nixpkgs {
            localSystem = { inherit system; };
            overlays = [ fenix.overlay ];
          };
          rustPlatform = pkgs.makeRustPlatform {
            inherit (fenix.packages.${system}.minimal) cargo rustc;
          };
        in
        {
          # defaultPackage = rustPlatform.buildRustPackage (package pkgs);
          devShell = import ./devshell.nix { inherit pkgs; };
        }
      );
}
