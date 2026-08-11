{ pkgs, pkgs-unstable, ... }:

let
  icons = import ../lib/icons.nix { inherit pkgs; };
in
{
  environment.systemPackages = with pkgs; [
    # Browsers
    pkgs-unstable.google-chrome

    # Development
    dbeaver-bin

    # Media & Graphics
    gthumb
    gimp
    loupe
    inkscape
    obs-studio
    celluloid

    # Theming
    icons.tela-circle-green
  ];
}
