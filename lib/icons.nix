{ pkgs }:
{
  # Single source of truth for the system's icon theme override.
  # Referenced from both the system modules and home-manager so the greeter
  # and the user session use the exact same theme.
  tela-circle-green = pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; };
}
