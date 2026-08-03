{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Browsers
    google-chrome

    # Development
    vscode
    dbeaver-bin
    pgadmin4-desktopmode

    # Media & Graphics
    gthumb
    gimp
    loupe
    inkscape
    obs-studio
    celluloid

    # Theming
    (tela-circle-icon-theme.override { colorVariants = [ "green" ]; })
  ];
}
