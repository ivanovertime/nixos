{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Theming
    tela-circle-green
  ];
}
