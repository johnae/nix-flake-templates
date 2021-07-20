{ pkgs }:

let
  inherit (pkgs.fenix.default)
    cargo
    clippy-preview
    rust-std
    rustc
    rustfmt-preview
  ;
  inherit (pkgs.fenix.latest)
    rust-src
  ;
in

pkgs.mkShell {
  buildInputs = [
    cargo
    clippy-preview
    rust-std
    rustc
    rustfmt-preview
    rust-src
    pkgs.rust-analyzer
    pkgs.gcc
    pkgs.openssl
    pkgs.pkg-config
    pkgs.skim
  ];
}
