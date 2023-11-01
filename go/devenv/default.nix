{
  inputs,
  pkgs,
  ansiEscape,
  ...
}: rec {
  name = "Go application";
  languages.go.enable = true;
  languages.nix.enable = true;
  packages = with pkgs; [
    alejandra
  ];
  enterShell = ansiEscape ''
     echo -e "
      {bold}{103}${name}{reset}

      This is a basic go application flake.
    "
  '';
}
