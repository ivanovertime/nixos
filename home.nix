{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./home/packages.nix
    ./home/neovim.nix
    ./home/kitty.nix
    ./home/ranger.nix
    ./home/tmux.nix
    ./home/hyprland.nix
    ./home/waybar.nix
    ./home/wofi.nix
    ./home/mako.nix
    ./home/gtk.nix
  ];

  home.username = "ivan";
  home.homeDirectory = "/home/ivan";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
