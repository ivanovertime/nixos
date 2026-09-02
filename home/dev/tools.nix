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
    gemini-cli
    unzip
    htop
  ];
}
