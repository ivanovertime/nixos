{ ... }:

{
  xdg.configFile."waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 34,
      "spacing": 6,
      "margin-top": 6,
      "margin-left": 10,
      "margin-right": 10,

      "modules-left": ["hyprland/workspaces", "hyprland/window"],
      "modules-center": ["clock"],
      "modules-right": ["tray", "pulseaudio", "network", "cpu", "memory", "battery"],

      "hyprland/workspaces": {
        "format": "{name}",
        "on-click": "activate",
        "sort-by-number": true
      },

      "hyprland/window": {
        "max-length": 60,
        "separate-outputs": true
      },

      "clock": {
        "format": "{:%a %d %b  %H:%M}",
        "tooltip-format": "<tt><small>{calendar}</small></tt>"
      },

      "cpu": {
        "format": "  {usage}%",
        "interval": 2
      },

      "memory": {
        "format": "  {percentage}%"
      },

      "network": {
        "format-wifi": "  {signalStrength}%",
        "format-ethernet": "  wired",
        "format-disconnected": "  off",
        "tooltip-format": "{ifname}: {ipaddr}",
        "on-click": "nm-connection-editor"
      },

      "pulseaudio": {
        "format": "{icon}  {volume}%",
        "format-muted": "  muted",
        "format-icons": { "default": ["", "", ""] },
        "on-click": "pavucontrol"
      },

      "battery": {
        "states": { "warning": 30, "critical": 15 },
        "format": "{icon}  {capacity}%",
        "format-charging": "  {capacity}%",
        "format-icons": ["", "", "", "", ""]
      },

      "tray": {
        "icon-size": 16,
        "spacing": 8
      }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    window#waybar {
      background: rgba(29, 32, 33, 0.85);
      color: #ebdbb2;
      border-radius: 10px;
    }

    #workspaces button {
      padding: 0 8px;
      color: #a89984;
      background: transparent;
    }

    #workspaces button.active {
      color: #1d2021;
      background: #fe8019;
      border-radius: 8px;
    }

    #workspaces button:hover {
      color: #ebdbb2;
      background: #3c3836;
      border-radius: 8px;
    }

    #window {
      color: #a89984;
      padding: 0 8px;
    }

    #clock,
    #cpu,
    #memory,
    #network,
    #pulseaudio,
    #battery,
    #tray {
      padding: 0 10px;
      color: #ebdbb2;
    }

    #cpu { color: #b8bb26; }
    #memory { color: #8ec07c; }
    #network { color: #83a598; }
    #pulseaudio { color: #fabd2f; }
    #battery { color: #d3869b; }

    #battery.warning { color: #fabd2f; }
    #battery.critical { color: #fb4934; }
    #pulseaudio.muted { color: #928374; }
  '';
}
