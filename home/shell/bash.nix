{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      yazi = "yazi";
      yy = "yazi";
      ls = "eza --icons=always --group-directories-first";
      ll = "eza --long --git --icons=always --group-directories-first --header";
      la = "eza --all --icons=always --group-directories-first";
      lla = "eza --long --all --git --icons=always --group-directories-first --header";
      lt = "eza --tree --icons=always";
    };
  };
}
