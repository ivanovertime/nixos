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
    set -g status-style bg=default,fg='#ebdbb2'
    set -g status-left-length 30
    set -g status-right-length 80
    set -g status-left '#[fg=#b8bb26,bold]#S '
    set -g status-right '#[fg=#83a598]%Y-%m-%d #[fg=#d3869b]%H:%M '

    setw -g window-status-format '#[fg=#a89984] #I:#W '
    setw -g window-status-current-format '#[fg=#1d2021,bg=#fabd2f,bold] #I:#W '
    setw -g window-status-separator ""

    set -g pane-border-style fg='#665c54'
    set -g pane-active-border-style fg='#b8bb26'
    set -g message-style bg='#3c3836',fg='#ebdbb2'
    set -g mode-style bg='#83a598',fg='#1d2021'

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
