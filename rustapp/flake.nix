{
  description = "A Rust app";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    dream2nix,
    flake-utils,
    devshell,
    fenix,
    nixpkgs,
  }: let
    l = nixpkgs.lib // builtins;
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlay
          fenix.overlay
        ];
      };

    initD2N = pkgs:
      dream2nix.lib.init {
        inherit pkgs;
        config.projectRoot = ./.;
        config.disableIfdWarning = true;
      };

    makeOutputs = pkgs: let
      outputs = (initD2N pkgs).makeOutputs {
        source = ./.;
        settings = [
          {
            builder = "crane";
            translator = "cargo-lock";
          }
        ];
      };
    in {
      packages.${pkgs.system} = outputs.packages;
    };
    allOutputs = l.map makeOutputs (map pkgsFor flake-utils.lib.defaultSystems);
    outputs = l.foldl' l.recursiveUpdate {} allOutputs;
  in
    outputs
    // (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = pkgsFor system;
    in {
      devShells.default = pkgs.devshell.mkShell {
        imports = [
          (pkgs.devshell.importTOML ./devshell.toml)
        ];
      };
    }));
}
