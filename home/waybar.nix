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
      "modules-right": ["tray", "pulseaudio", "cpu", "memory", "battery", "custom/logout", "custom/suspend", "custom/reboot", "custom/power"],

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
        "format": "  {:%a %d %b  %H:%M}",
        "tooltip-format": "<tt><small>{calendar}</small></tt>"
      },

      "cpu": {
        "format": "  {usage}%",
        "interval": 2
      },

      "memory": {
        "format": "  {percentage}%"
      },

      "pulseaudio": {
        "format": "{icon}  {volume}%",
        "format-muted": "󰖁  muted",
        "format-icons": { "default": ["", "", ""] },
        "on-click": "pavucontrol"
      },

      "battery": {
        "states": { "warning": 30, "critical": 15 },
        "format": "{icon}  {capacity}%",
        "format-charging": "  {capacity}%",
        "format-icons": ["", "", "", "", ""]
      },

      "tray": {
        "icon-size": 16,
        "spacing": 8
      },

      "custom/logout": {
        "format": "󰍃",
        "tooltip": "Logout",
        "on-click": "hyprctl dispatch exit"
      },

      "custom/suspend": {
        "format": "󰒲",
        "tooltip": "Suspend",
        "on-click": "systemctl suspend"
      },

      "custom/reboot": {
        "format": "",
        "tooltip": "Reboot",
        "on-click": "systemctl reboot"
      },

      "custom/power": {
        "format": "",
        "tooltip": "Power off",
        "on-click": "systemctl poweroff"
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
      background: rgba(39, 46, 51, 0.85);
      color: #d3c6aa;
      border-radius: 10px;
    }

    #workspaces button {
      padding: 0 8px;
      color: #859289;
      background: transparent;
    }

    #workspaces button.active {
      color: #272e33;
      background: #a7c080;
      border-radius: 8px;
    }

    #workspaces button:hover {
      color: #d3c6aa;
      background: #2e383c;
      border-radius: 8px;
    }

    #window {
      color: #859289;
      padding: 0 8px;
    }

    #clock,
    #cpu,
    #memory,
    #pulseaudio,
    #battery,
    #tray,
    #custom-logout,
    #custom-suspend,
    #custom-reboot,
    #custom-power {
      padding: 0 10px;
      color: #d3c6aa;
    }

    #cpu { color: #a7c080; }
    #memory { color: #7fbbb3; }
    #pulseaudio { color: #dbbc7f; }
    #battery { color: #d699b6; }
    #custom-logout { color: #e69875; }
    #custom-suspend { color: #7fbbb3; }
    #custom-reboot { color: #dbbc7f; }
    #custom-power { color: #e67e80; }

    #battery.warning { color: #e69875; }
    #battery.critical { color: #e67e80; }
    #pulseaudio.muted { color: #859289; }

    #custom-logout:hover,
    #custom-suspend:hover,
    #custom-reboot:hover,
    #custom-power:hover {
      background: #2e383c;
      border-radius: 8px;
    }
  '';
}
