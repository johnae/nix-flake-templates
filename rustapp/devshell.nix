{ pkgs }:

pkgs.mkShell {
  buildInputs = [
    (pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy-preview"
      "rust-src"
      "rust-std"
      "rustc"
      "rustfmt-preview"
    ])
    pkgs.rust-analyzer-nightly
  ];
}
