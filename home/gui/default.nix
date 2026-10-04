{ pkgs, pkgs-unstable, ... }:

let
  # Chrome with VA-API decode. These are the two feature names that still exist
  # in Chrome 154's string table (`VaapiVideoDecoder`, `AcceleratedVideoDecodeLinuxGL`);
  # the older `VaapiVideoDecodeLinuxGL` is gone. amdgpu's VA-API driver
  # (radeonsi_drv_video.so) is already on LD_LIBRARY_PATH via nixpkgs' libvaSupport.
  # Check chrome://gpu ("Video Decode: Hardware accelerated") and `vainfo`.
  google-chrome-vaapi = pkgs-unstable.google-chrome.override {
    commandLineArgs = "--enable-features=VaapiVideoDecoder,AcceleratedVideoDecodeLinuxGL";
  };
in
{
  home.packages = with pkgs; [
    # Browsers
    firefox
    google-chrome-vaapi

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
    proton-vpn
  ];
}
