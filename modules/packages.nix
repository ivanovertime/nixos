{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Browsers
    google-chrome

    # Development
    vscode
    dbeaver-bin

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
