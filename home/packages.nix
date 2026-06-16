{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    ranger
    tmux
    zathura
    mpv

    # Hyprland desktop environment
    waybar
    wofi
    mako
    libnotify
    swaybg
    hyprlock
    hypridle
    hyprshot
    hyprpicker
    hyprpolkitagent
    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    wlogout
    nautilus
    file-roller
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum
  ] ++ [
    pkgs-unstable.kitty
  ];
}
