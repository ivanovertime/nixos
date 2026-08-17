{ ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
      set -g history-limit 100000
      set -g status-interval 5
      set -g status-justify centre
      set -g status-left-length 40
      set -g status-right-length 90
      set -g status-left "#[fg=green]#H"
      set -g status-right "#[fg=yellow]%Y-%m-%d %H:%M:%S"
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
