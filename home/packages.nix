{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    ranger
    tmux
  ] ++ [
    pkgs-unstable.kitty
  ];
}
