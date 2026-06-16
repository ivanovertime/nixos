{ ... }:

{
  # Mako notification daemon (Everforest dark hard). Started via Hyprland exec-once.
  xdg.configFile."mako/config".text = ''
    font=JetBrainsMono Nerd Font 11
    background-color=#272e33f0
    text-color=#d3c6aa
    border-color=#a7c080
    progress-color=over #2e383c
    border-size=2
    border-radius=10
    padding=12
    margin=10
    default-timeout=5000
    max-visible=5
    anchor=top-right
    icons=1

    [urgency=low]
    border-color=#859289

    [urgency=high]
    border-color=#e67e80
    default-timeout=0
  '';
}
