{
  inputs,
  pkgs,
  ansiEscape,
  ...
}: rec {
  name = "Zig application";
  languages.zig.enable = true;
  languages.nix.enable = true;
  packages = with pkgs; [
    zls
  ];
  enterShell = ansiEscape ''
     echo -e "
      {bold}{160}${name}{reset}

      This is a basic zig application flake.
    "
  '';
}
