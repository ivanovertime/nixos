{ pkgs, ... }:

{
  services.livebook = {
    enableUserService = true;
    extraPackages = with pkgs; [
      git
      gnutar
      gzip
      curl
      gcc
      gnumake
      patch
    ];
  };
}
