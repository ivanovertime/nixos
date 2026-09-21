{ ... }:

{
  programs.eza = {
    enable = true;
    icons = "always";
    colors = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
