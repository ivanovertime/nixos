{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # Browsers
    pkgs-unstable.google-chrome

    # Development
    pkgs-unstable.dbeaver-bin

    # Media & Graphics
    gthumb
    loupe
    pkgs-unstable.inkscape
    obs-studio
    celluloid

    # Theming
    tela-circle-green

    # VPN
    protonvpn-gui
  ];
}
