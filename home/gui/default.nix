{ pkgs, pkgs-unstable, ... }:

let
  # current-generation Chrome feature names; verify at chrome://gpu
  google-chrome-vaapi = pkgs-unstable.google-chrome.override {
    commandLineArgs = "--enable-features=VaapiVideoDecoder,AcceleratedVideoDecodeLinuxGL";
  };

  # Spotify's bundled Chromium defaults to X11 and xwayland is disabled here,
  # so the ozone hint has to be on the command line.
  spotify-wayland = pkgs.symlinkJoin {
    name = "spotify-${pkgs.spotify.version}";
    paths = [ pkgs.spotify ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify --add-flags "--ozone-platform-hint=auto"
    '';
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
    spotify-wayland
  ];
}
