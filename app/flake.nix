{
  description = "Some application";

  outputs = { self, nixpkgs, ... }:
    let
      package = pkgs: {
        pname = "my-app";
        version = "v0.0.0";
        src = self;
        doCheck = false;
        nativeBuildInputs = [ pkgs.pkgconfig ];
        buildInputs = [ ];
        meta = {
          license = pkgs.stdenv.lib.licenses.mit;
          maintainers = [
            {
              email = "me@myself.org";
              github = "me";
              name = "Me Me Me";
            }
          ];
        };
      };
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
      let
        pkgs = forAllSystems (system: import nixpkgs {
          localSystem = { inherit system; };
          overlays = [ self.overlay ];
        });
      in
        {
          overlay = final: prev: {
            my-app = prev.stdenv.mkDerivation (package prev);
          };
          defaultPackage = forAllSystems (system: pkgs.${system}.stdenv.mkDerivation (package pkgs.${system}));
          devShell = forAllSystems (system: import ./devshell.nix { pkgs = pkgs.${system}; });
        };
}
