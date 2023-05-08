{
  pkgs,
  ansiEscape,
  ...
}: {
  name = "devenv";

  packages = with pkgs; [
  ];

  enterShell = ansiEscape ''
     echo -e "
      {bold}{106}Devenv{reset}

      Yo hello!
    "
  '';
}
