#{ansiEsc, mkDevShell, sops }: ## just add dependencies here and then include them in the "packages" below within mkDevShell
{ ansiEsc, mkDevShell }:

let
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
    ${bold}${green}   Welcome to Dev SH.${reset}
  '';
}
