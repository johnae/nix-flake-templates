{ pkgs ? import <nixpkgs> { } }:
let
  hello = pkgs.writeStrictShellScriptBin "hello" ''
    echo hello world
  '';
in
pkgs.mkShell {
  buildInputs = [ hello ];
}
