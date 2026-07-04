{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Browsers
    google-chrome

    # Development
    vscode
    dbeaver-bin

    # Media & Graphics
    gimp
    loupe
    inkscape
    obs-studio
    celluloid
    transmission_4-gtk

    # Theming
    (tela-circle-icon-theme.override { colorVariants = [ "green" ]; })
  ];
}
