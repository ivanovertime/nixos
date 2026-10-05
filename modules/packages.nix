{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Theming
    tela-circle-green

    # Video thumbnails (mp4, mkv, webm, …) in file managers and pickers. Ships
    # share/thumbnailers/ffmpegthumbnailer*.thumbnailer; without it the only
    # thumbnailer on the system is COSMIC Files' own one for .exe files.
    ffmpegthumbnailer
  ];
}
