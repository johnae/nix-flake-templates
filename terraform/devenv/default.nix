{
  inputs,
  pkgs,
  ansiEscape,
  ...
}: rec {
  name = "Terraform";
  languages.terraform.enable = true;
  languages.nix.enable = true;
  packages = with pkgs; [
    alejandra
    taplo
    tflint
  ];
  enterShell = ansiEscape ''
     echo -e "
      {bold}{120}${name}{reset}

      This is a basic terraform flake.
    "
  '';
}
