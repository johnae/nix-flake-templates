#{mkDevShell, sops, kubectl }: ## just add dependencies here and then include them in the "packages" below within mkDevShell
{ mkDevShell }:

let
  ansiEsc = code: "[${toString code}m";
  reset = ansiEsc 0;
  bold = ansiEsc 1;
  green = ansiEsc 32;
in
mkDevShell {
  name = "devsh";
  packages = [
    # sops
  ];
  intro = ''
    ${bold}${green}   Hello, world.${reset}
  '';
}
