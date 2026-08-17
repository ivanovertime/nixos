{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    pkgs-unstable."antigravity-ide"
    pkgs-unstable.vscode
    # Copilot deps
    bubblewrap
    socat
  ];
}
