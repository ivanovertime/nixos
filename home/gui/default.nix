{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    firefox
    pkgs-unstable.google-chrome

    # Development
    pkgs-unstable.dbeaver-bin

    # Media & Graphics
    qbittorrent
    python3Packages.subliminal
    gthumb
    loupe
    pkgs-unstable.inkscape
    obs-studio

    # Tools
    gnome-disk-utility
    gnome-system-monitor
    protonvpn-gui
  ];
}
