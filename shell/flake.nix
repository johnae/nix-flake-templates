{
  description = "A simple flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
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
      ];
      systems = inputs.flake-utils.lib.defaultSystems;
      shell = ./shell.nix;
    }
  ;
}
