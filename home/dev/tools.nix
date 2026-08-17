{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    ripgrep
    shellcheck
    gh
    curl
    wget
    unzip
    htop
  ];
}
