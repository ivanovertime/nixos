{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tela-circle-green

    # video thumbnails in file managers
    ffmpegthumbnailer
  ];
}
