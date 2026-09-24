{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Media
    qbittorrent
    python3Packages.subliminal

    # Tools
    gnome-disk-utility
    gnome-system-monitor
  ];
}
