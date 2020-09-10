{ pkgs ? import <nixpkgs> { } }:
pkgs.mkDevShell.fromTOML ./devshell.toml
