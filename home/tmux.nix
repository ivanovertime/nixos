{ ... }:

{
  home.file.".tmux.conf".text = ''
    # Prefix
    set -g prefix C-b

    # General behavior
    set -g mouse on
    set -g history-limit 10000
    set -g base-index 1
    setw -g pane-base-index 1
    set -g renumber-windows on
    set -g set-clipboard on
    set -g allow-passthrough on
    set -g default-terminal "tmux-256color"
    set -as terminal-features ',xterm-kitty:RGB'

    # Keep pane backgrounds owned by Kitty; only style tmux chrome.
    set -g status-position bottom
    set -g status-style bg=default,fg='#d3c6aa'
    set -g status-left-length 30
    set -g status-right-length 80
    set -g status-left '#[fg=#a7c080,bold]#S '
    set -g status-right '#[fg=#7fbbb3]%Y-%m-%d #[fg=#d699b6]%H:%M '

    setw -g window-status-format '#[fg=#859289] #I:#W '
    setw -g window-status-current-format '#[fg=#272e33,bg=#dbbc7f,bold] #I:#W '
    setw -g window-status-separator ""

    set -g pane-border-style fg='#475258'
    set -g pane-active-border-style fg='#a7c080'
    set -g message-style bg='#2e383c',fg='#d3c6aa'
    set -g mode-style bg='#7fbbb3',fg='#272e33'

    # Navigation and splits
    bind - split-window -v
    bind \\ split-window -h
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    bind H resize-pane -L 5
    bind J resize-pane -D 3
    bind K resize-pane -U 3
    bind L resize-pane -R 5

    # Reload
    bind r source-file ~/.tmux.conf \; display-message 'tmux.conf reloaded'
  '';
}
