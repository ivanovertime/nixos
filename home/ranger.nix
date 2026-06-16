{ ... }:

{
  xdg.configFile."ranger/rc.conf".text = ''
    set preview_files true
    set preview_images true
    set preview_images_method kitty
    set draw_borders true
    set preview_directories true
    set collapse_preview true
  '';
}
