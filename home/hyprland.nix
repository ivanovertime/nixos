{ ... }:

{
  # Hyprland itself is enabled at the system level (programs.hyprland). Here we
  # only manage the user configuration files so the config stays robust against
  # the pinned home-manager version.
  xdg.configFile."hypr/hyprland.conf".text = ''
    ###################
    ### MONITORS    ###
    ###################
    # External display (left), laptop panel (right)
    monitor = HDMI-A-1, 1920x1080@74.973, 0x0, 1
    monitor = eDP-1, 1920x1080@60, 1920x0, 1

    ###################
    ### PROGRAMS    ###
    ###################
    $terminal = kitty
    $fileManager = nautilus
    $menu = wofi --show drun
    $lock = hyprlock

    ###################
    ### AUTOSTART   ###
    ###################
    exec-once = sh -lc 'if [ -f "$HOME/Pictures/wallpapers/current" ]; then swaybg -m fill -i "$HOME/Pictures/wallpapers/current"; elif [ -f "$HOME/Pictures/wallpapers/current.jpg" ]; then swaybg -m fill -i "$HOME/Pictures/wallpapers/current.jpg"; elif [ -f "$HOME/Pictures/wallpapers/current.png" ]; then swaybg -m fill -i "$HOME/Pictures/wallpapers/current.png"; else swaybg -c 272e33; fi'
    exec-once = env GTK_THEME=Everforest-Dark-BL GTK_ICON_THEME=Tela-circle-dark waybar
    exec-once = mako
    exec-once = hypridle
    exec-once = nm-applet --indicator
    exec-once = blueman-applet
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store
    exec-once = systemctl --user start hyprpolkitagent

    ###################
    ### ENVIRONMENT ###
    ###################
    env = XCURSOR_SIZE, 24
    env = HYPRCURSOR_SIZE, 24
    # Ensure Qt apps pick up the qt6ct platform theme even when the session
    # vars file isn't sourced (e.g. launched from a display manager).
    env = QT_QPA_PLATFORMTHEME, qt6ct

    ###################
    ### LOOK & FEEL ###
    ###################
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(e69875ee) rgba(dbbc7fee) 45deg
        col.inactive_border = rgba(475258aa)
        resize_on_border = true
        layout = dwindle
    }

    decoration {
        rounding = 8
        active_opacity = 1.0
        inactive_opacity = 0.95
        blur {
            enabled = true
            size = 6
            passes = 2
        }
        shadow {
            enabled = true
            range = 12
            render_power = 3
            color = rgba(1f2428ee)
        }
    }

    animations {
        enabled = true
        bezier = easeOutQuint, 0.23, 1, 0.32, 1
        animation = windows, 1, 4, easeOutQuint
        animation = windowsOut, 1, 4, easeOutQuint, popin 80%
        animation = fade, 1, 4, default
        animation = workspaces, 1, 5, easeOutQuint, slide
    }

    dwindle {
        pseudotile = true
        preserve_split = true
    }

    master {
        new_status = master
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        force_default_wallpaper = 0
    }

    ###################
    ### INPUT       ###
    ###################
    input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
        touchpad {
            natural_scroll = true
            tap-to-click = true
        }
    }

    gestures {
        workspace_swipe_touch = 3
    }

    ###################
    ### KEYBINDINGS ###
    ###################
    $mod = SUPER

    bind = $mod, Return, exec, $terminal
    bind = $mod, Q, killactive
    bind = $mod SHIFT, M, exit
    bind = $mod, E, exec, $fileManager
    bind = $mod, R, exec, $menu
    bind = $mod SHIFT, L, exec, $lock
    bind = $mod, V, togglefloating
    bind = $mod, F, fullscreen
    bind = $mod, J, togglesplit
    bind = $mod, P, pseudo
    bind = $mod SHIFT, W, exec, sh -lc 'pkill -x swaybg || true; if [ -f "$HOME/Pictures/wallpapers/current" ]; then swaybg -m fill -i "$HOME/Pictures/wallpapers/current"; elif [ -f "$HOME/Pictures/wallpapers/current.jpg" ]; then swaybg -m fill -i "$HOME/Pictures/wallpapers/current.jpg"; elif [ -f "$HOME/Pictures/wallpapers/current.png" ]; then swaybg -m fill -i "$HOME/Pictures/wallpapers/current.png"; else swaybg -c 272e33; fi'

    # Clipboard history (via wofi)
    bind = $mod SHIFT, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

    # Move focus
    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d
    bind = $mod, H, movefocus, l
    bind = $mod, L, movefocus, r
    bind = $mod, K, movefocus, u
    # (J is bound to togglesplit; use arrows for down focus)

    # Move windows
    bind = $mod SHIFT, left, movewindow, l
    bind = $mod SHIFT, right, movewindow, r
    bind = $mod SHIFT, up, movewindow, u
    bind = $mod SHIFT, down, movewindow, d

    # Workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    # Move active window to a workspace
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10

    # Scratchpad / special workspace
    bind = $mod, S, togglespecialworkspace, magic
    bind = $mod SHIFT, S, movetoworkspace, special:magic

    # Scroll through workspaces
    bind = $mod, mouse_down, workspace, e+1
    bind = $mod, mouse_up, workspace, e-1

    # Move/resize with mouse
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    # Screenshots (hyprshot)
    bind = , Print, exec, hyprshot -m region
    bind = $mod, Print, exec, hyprshot -m window
    bind = SHIFT, Print, exec, hyprshot -m output

    # Audio (wireplumber) — repeats while held
    bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindl  = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindl  = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # Brightness
    bindel = , XF86MonBrightnessUp, exec, brightnessctl s 5%+
    bindel = , XF86MonBrightnessDown, exec, brightnessctl s 5%-

    # Media keys
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPrev, exec, playerctl previous

    ###################
    ### WINDOW RULES ##
    ###################
    windowrulev2 = suppressevent maximize, class:.*
    windowrulev2 = float, class:^(pavucontrol)$
    windowrulev2 = float, class:^(nm-connection-editor)$
    windowrulev2 = float, title:^(Open File)$
    windowrulev2 = float, title:^(Save File)$
  '';

    # Lock screen (hyprlock), Everforest themed.
  xdg.configFile."hypr/hyprlock.conf".text = ''
    background {
        monitor =
                color = rgba(39, 46, 51, 1.0)
    }

    input-field {
        monitor =
        size = 280, 50
        outline_thickness = 2
        dots_size = 0.3
        dots_spacing = 0.3
        outer_color = rgba(a7c080ff)
        inner_color = rgba(323d43ff)
        font_color = rgba(d3c6aaff)
        placeholder_text = <i>Password...</i>
        fade_on_empty = true
        position = 0, -20
        halign = center
        valign = center
    }

    label {
        monitor =
        text = $TIME
        color = rgba(d3c6aaff)
        font_size = 64
        font_family = JetBrainsMono Nerd Font
        position = 0, 140
        halign = center
        valign = center
    }

    label {
        monitor =
        text = cmd[update:1000] echo "$(date '+%A, %d %B')"
        color = rgba(859289ff)
        font_size = 20
        font_family = JetBrainsMono Nerd Font
        position = 0, 80
        halign = center
        valign = center
    }
  '';

  # Idle management (hypridle): lock, dpms off, then suspend.
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 300
        on-timeout = loginctl lock-session
    }

    listener {
        timeout = 360
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }

    listener {
        timeout = 900
        on-timeout = systemctl suspend
    }
  '';
}
