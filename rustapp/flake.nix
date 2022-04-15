{
  description = "Bongo bong";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    fenix.url = "github:nix-community/fenix";
    nix-misc = {
      url = "github:johnae/nix-misc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    devshell,
    nix-misc,
    fenix,
    flake-utils,
  }: let
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlay
          nix-misc.overlay
          fenix.overlay
          (final: prev: {
            rustWithComponents = prev.fenix.complete.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
            ];
          })
        ];
      };
    forAllDefaultSystems = f:
      flake-utils.lib.eachDefaultSystem
      (system: f system (pkgsFor system));
  in
    forAllDefaultSystems (
      system: pkgs: {
        devShell = pkgs.devshell.mkShell {
          imports = [
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };
      }
    );
}
