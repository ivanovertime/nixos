{ ... }:

{
  # Mako notification daemon (Gruvbox dark). Started via Hyprland exec-once.
  xdg.configFile."mako/config".text = ''
    font=JetBrainsMono Nerd Font 11
    background-color=#1d2021f0
    text-color=#ebdbb2
    border-color=#fe8019
    progress-color=over #3c3836
    border-size=2
    border-radius=10
    padding=12
    margin=10
    default-timeout=5000
    max-visible=5
    anchor=top-right
    icons=1

    [urgency=low]
    border-color=#928374

    [urgency=high]
    border-color=#fb4934
    default-timeout=0
  '';
}
