{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    ./devenv.nix
  ];
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
      ];
      config = {};
    };
  };
}
