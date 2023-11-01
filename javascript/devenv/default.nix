{
  inputs,
  pkgs,
  ansiEscape,
  ...
}: rec {
  name = "JS/TS application";
  languages.javascript.enable = true;
  languages.typescript.enable = true;
  languages.nix.enable = true;
  packages = with pkgs; [
    alejandra
    taplo
  ];
  enterShell = ansiEscape ''
     echo -e "
      {bold}{98}${name}{reset}

      This is a basic javascript application flake.
    "
  '';
}
