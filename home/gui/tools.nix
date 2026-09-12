{ pkgs, ... }:

{
  home.packages = [
    pkgs.gnome-disk-utility
    pkgs.gnome-system-monitor
  ];
}
