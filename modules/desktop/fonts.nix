{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMonoNL Nerd Font Mono"
        "JetBrainsMonoNL Nerd Font"
        "JetBrainsMono Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
    };
  };
}
