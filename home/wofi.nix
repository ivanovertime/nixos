{ ... }:

{
  xdg.configFile."wofi/config".text = ''
    width=600
    height=400
    location=center
    show=drun
    prompt=Search...
    filter_rate=100
    allow_markup=true
    no_actions=true
    halign=fill
    orientation=vertical
    content_halign=fill
    insensitive=true
    allow_images=true
    image_size=28
    gtk_dark=true
  '';

  xdg.configFile."wofi/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 14px;
    }

    window {
      margin: 0;
      background-color: rgba(39, 46, 51, 0.95);
      border: 2px solid #a7c080;
      border-radius: 12px;
    }

    #input {
      margin: 10px;
      padding: 8px;
      color: #d3c6aa;
      background-color: #323d43;
      border: none;
      border-radius: 8px;
    }

    #inner-box {
      margin: 6px;
      background-color: transparent;
    }

    #outer-box {
      margin: 4px;
      background-color: transparent;
    }

    #scroll {
      margin: 0;
    }

    #text {
      padding: 4px;
      color: #d3c6aa;
    }

    #entry {
      padding: 6px;
      border-radius: 8px;
    }

    #entry:selected {
      background-color: #a7c080;
    }

    #entry:selected #text {
      color: #272e33;
    }
  '';
}
