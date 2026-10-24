{ pkgs, pkgs-unstable, ... }:

let
  # current-generation Chrome feature names; verify at chrome://gpu
  google-chrome-vaapi = pkgs-unstable.google-chrome.override {
    commandLineArgs = "--enable-features=VaapiVideoDecoder,AcceleratedVideoDecodeLinuxGL";
  };
in
{
  home.packages = with pkgs; [
    google-chrome-vaapi
    pkgs-unstable.dbeaver-bin
    qbittorrent
    python3Packages.subliminal
    gthumb
    pkgs-unstable.inkscape
    obs-studio
    cosmic-monitor
    cosmic-ext-applet-sysinfo
    gnome-disk-utility
    proton-vpn
  ];
}
