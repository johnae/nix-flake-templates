{ pkgs ? import <nixpkgs> { } }:
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
