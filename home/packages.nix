{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    ranger
    tmux

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
  ] ++ [
    pkgs-unstable.kitty
  ];
}
