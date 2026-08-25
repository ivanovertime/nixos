{ pkgs, pkgs-unstable, ... }:

let
  icons = import ../lib/icons.nix { inherit pkgs; };
in
{
  environment.systemPackages = with pkgs; [
    # Browsers
    pkgs-unstable.google-chrome
    pkgs-unstable.firefox
    pkgs-unstable.thunderbird

    # Development
    postgresql
    pkgs-unstable.dbeaver-bin

    # Media & Graphics
    gthumb
    gimp
    loupe
    pkgs-unstable.inkscape
    obs-studio
    celluloid

    # Theming
    icons.tela-circle-green
  ];
}
