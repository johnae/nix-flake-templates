{inputs, ...}: {
  imports = [
    ./devenv.nix
  ];
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [];
      config = {
        allowUnfree = true;
      };
    };
  };
}
