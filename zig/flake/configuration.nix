{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    ./devenv.nix
    ./packages.nix
  ];
}
