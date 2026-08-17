{ pkgs, ... }:

{
  home.packages = with pkgs; [
    qbittorrent
    python3Packages.subliminal
  ];
}
