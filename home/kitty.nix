{ ... }:

{
  xdg.configFile."kitty/kitty.conf".text = ''
    # Platform and rendering
    linux_display_server wayland

    # Font and text
    font_family JetBrainsMono Nerd Font Mono
    font_size 12.0
    disable_ligatures cursor

    # Theme (Everforest Dark Hard)
    foreground            #d3c6aa
    background            #272e33
    selection_foreground  #272e33
    selection_background  #d3c6aa
    cursor                #a7c080
    cursor_text_color     #272e33

    # Normal colors
    color0  #272e33
    color1  #e67e80
    color2  #a7c080
    color3  #dbbc7f
    color4  #7fbbb3
    color5  #d699b6
    color6  #83c092
    color7  #d3c6aa

    # Bright colors
    color8  #475258
    color9  #e67e80
    color10 #a7c080
    color11 #dbbc7f
    color12 #7fbbb3
    color13 #d699b6
    color14 #83c092
    color15 #e5dfc5

    # Window appearance
    background_opacity 0.85
    hide_window_decorations yes
    window_padding_width 8
    initial_window_width 120c
    initial_window_height 34c
    remember_window_size no

    # Tabs/UX
    tab_bar_style hidden
    scrollback_lines 10000
    enable_audio_bell no
    cursor_shape beam
    cursor_blink_interval 0

    # Start tmux automatically
    shell tmux new-session -A -s main

    # Start with a maximized OS window
    startup_session session.conf

    # Clipboard
    copy_on_select yes

    # Keymaps similar to previous WezTerm setup
    map ctrl+shift+c copy_to_clipboard
    map ctrl+shift+v paste_from_clipboard
    map ctrl+plus  change_font_size all +1.0
    map ctrl+minus change_font_size all -1.0
    map ctrl+0     change_font_size all 0

    # Leader-style sequences (Ctrl+a, then key)
    map ctrl+a>enter launch --location=hsplit
    map ctrl+a>backslash launch --location=vsplit
    map ctrl+a>h neighboring_window left
    map ctrl+a>j neighboring_window down
    map ctrl+a>k neighboring_window up
    map ctrl+a>l neighboring_window right
    map ctrl+a>x close_window
    map ctrl+a>z toggle_layout stack

    map ctrl+a>shift+h resize_window narrower 5
    map ctrl+a>shift+j resize_window taller 3
    map ctrl+a>shift+k resize_window shorter 3
    map ctrl+a>shift+l resize_window wider 5

    map ctrl+a>c new_tab
    map ctrl+a>n next_tab
    map ctrl+a>p previous_tab
    map ctrl+a>q close_tab

    # Reload config
    map ctrl+a>r load_config_file

    # Quick cheatsheet (leader is Ctrl+a)
    # Splits: Enter (horizontal), \\ (vertical)
    # Focus panes: h/j/k/l
    # Resize panes: Shift+h/j/k/l
    # Tabs: c (new), n/p (next/prev), q (close)
    # Other: x (close pane), z (toggle layout), r (reload kitty.conf)
  '';

  xdg.configFile."kitty/session.conf".text = ''
    # Ensure first OS window starts maximized
    os_window_state maximized
  '';
}
