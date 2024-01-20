{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    packages.default = pkgs.stdenv.mkDerivation {
      pname = "template";
      version = "0.0.0";
      src = ./.;

      nativeBuildInputs = [
        pkgs.zig.hook
        pkgs.zig
      ];
      buildInputs = [];
    };
  };
}
