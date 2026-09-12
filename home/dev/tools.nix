{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    ripgrep
    shellcheck
    gh
    curl
    jq
    wget
    unzip
    htop
  ];
}
