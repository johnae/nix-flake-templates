## The template this flake was based on can be found here:
## https://github.com/johnae/nix-flake-templates/devshell
{
  description = "A simple flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "snowflake";
      config.allowUnfree = true; ## we're fine using nonfree software
      preOverlays = [
        inputs.nix-misc.overlay
        inputs.devshell.overlay
      ];
      systems = inputs.flake-utils.lib.defaultSystems;
      shell = { pkgs ? import <nixpkgs> { } }:
        let
          inherit (pkgs.mkDevShell) fromData importTOML fromTOML;
          inherit (pkgs.lib) recursiveUpdate;
        in
        fromData (recursiveUpdate
          (importTOML ./devshell.toml)
          (
            if builtins.pathExists ./devshell.nix then
              import ./devshell.nix { inherit pkgs; }
            else { }
          ))
      ;
    }
  ;
}
