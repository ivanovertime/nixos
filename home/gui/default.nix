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
    pkgs-unstable.inkscape
    obs-studio

    # System monitoring. `cosmic-monitor` is System76's monitor (CPU temperature,
    # processes, GPU); the applet puts CPU and GPU temperature straight in the
    # panel. Both resolve to nixpkgs-unstable through the flake overlay, which is
    # where the COSMIC packages come from. Replaces gnome-system-monitor, which
    # shows no temperatures.
    cosmic-monitor
    cosmic-ext-applet-sysinfo

    # External-monitor brightness over DDC/CI. Needs hardware.i2c (see
    # modules/hardware/amd.nix); it cannot dim the internal panel — that is the
    # amdgpu_bl backlight the COSMIC brightness slider already drives.
    cosmic-ext-applet-external-monitor-brightness

    # Tools
    gnome-disk-utility
    proton-vpn
  ];
}
