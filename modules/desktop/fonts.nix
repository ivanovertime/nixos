{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      atkinson-hyperlegible-next
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMonoNL Nerd Font Mono"
        "JetBrainsMonoNL Nerd Font"
        "JetBrainsMono Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
      sansSerif = [ "Atkinson Hyperlegible Next" ];
      serif = [ "DejaVu Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
