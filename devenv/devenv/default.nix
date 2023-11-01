{
  inputs,
  pkgs,
  ansiEscape,
  ...
}: rec {
  name = "Devenv";
  languages.nix.enable = true;
  packages = with pkgs; [
    alejandra
  ];
  enterShell = ansiEscape ''
     echo -e "
      {bold}{106}${name}{reset}

      This is a basic devenv flake.
    "
  '';
}
