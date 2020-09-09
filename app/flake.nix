{
  description = "A flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nix-misc = {
    url = "github:johnae/nix-misc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    {
      overlay = final: prev: {
        helloApp = final.callPackage ./. { inherit self; };
      };
    } // (
      flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            defaultPackage =
              (import nixpkgs {
                inherit system;
                overlays = [ self.overlay inputs.nix-misc.overlay ];
              }).helloApp;
            helloApp = flake-utils.lib.mkApp {
              drv = defaultPackage;
              exePath = "/bin/hello";
            };
          in
          {
            inherit defaultPackage;
            packages = flake-utils.lib.flattenTree {
              helloApp = defaultPackage;
            };
            apps.helloApp = helloApp;
            defaultApp = helloApp;
            devShell = import ./shell.nix { inherit pkgs; };
          }
        )
    );
}
