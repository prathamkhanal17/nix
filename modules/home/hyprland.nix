{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      monitor = ",preferred,auto,auto";

      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";

      exec-once = [
        "waybar"
        "~/.config/hypr/scripts/set_wallpaper.sh"
        "hypridle"
        "swaync"
        "kdeconnectd & kdeconnect-indicator"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      ];

      input = {
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.2;
        };
        sensitivity = 0;
      };

      gestures = { workspace_swipe = true; };

      device = [
        { name = "epic-mouse-v1"; sensitivity = -0.5; }
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(D79921) rgb(fe8019) 120deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 0.90;
        inactive_opacity = 0.89;
        shadow = { enabled = true; range = 4; render_power = 3; color = "rgba(1a1a1aee)"; };
        blur = { enabled = true; size = 3; passes = 2; vibrancy = 0.1696; };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = { pseudotile = true; preserve_split = true; };
      master = { new_status = "master"; };
      misc = { force_default_wallpaper = -1; disable_hyprland_logo = false; };

      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, W, togglefloating,"
        "$mainMod, space, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, B, exec, $browser"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        ", XF86Calculator, exec, gnome-calculator"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        ", PRINT, exec, grim - | swappy -f -"
        "$mainMod Shift, PRINT, exec, grim -g \"$(slurp -d)\" - | swappy -f - && notify-send \"screenshot captured\""
        "$mainMod, N, exec, swaync-client -t"
        "$mainMod, V, exec, rofi -modi clipboard:/home/prathamk/.config/hypr/scripts/cliphist-rofi-image.sh -show clipboard -show-icons"
        "Alt, Tab, exec, rofi -show window"
        "$mainMod Shift, E, exec, rofi -show filebrowser"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 2.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      binde = [
        "$mainMod Shift, Right, resizeactive, 30 0"
        "$mainMod Shift, Left, resizeactive, -30 0"
        "$mainMod Shift, Up,resizeactive, 0 -30"
        "$mainMod Shift, Down, resizeactive, 0 30"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "float,class:org.gnome.Calculator,title:Calculator"
        "float,class:org.gnome.Calendar,title:Calendar"
        "float,class:org.gnome.clocks,title:Clocks"
        "float,class:nm-connection-editor,title:.*"
      ];

      windowrulev2 = [
        "float,size 80 24, center, class:kitty,title:btop-waybar"
        "size 1200 700, class:kitty,title:btop-waybar"
      ];
    };

    extraConfig = "";
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "notify-send \"lock!\"";
        unlock_cmd = "notify-send \"unlock!\"";
        before_sleep_cmd = "notify-send \"Zzz\"";
        after_sleep_cmd = "notify-send \"Awake!\"";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };
      listener = [
        { timeout = 500; on-timeout = "notify-send \"You are idle!\""; on-resume = "notify-send \"Welcome back!\""; }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      "$font" = "JetBrainsMono Nerd Font";
      general = { hide_cursor = true; };
      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };
      background = { monitor = ""; path = "screenshot"; blur_passes = 2; };
      "input-field" = {
        monitor = "";
        size = "20%, 5%";
        outline_thickness = 3;
        inner_color = "rgba(0, 0, 0, 0.0)";
        outer_color = "rgb(fe8019) rgb(fabd2f) 45deg";
        check_color = "rgb(fabd2f) rgb(d65d0e) 120deg";
        fail_color = "rgb(fabd2f) rgb(fb4934) 40deg";
        font_color = "rgb(143, 143, 143)";
        fade_on_empty = false;
        rounding = 15;
        font_family = "$font";
        placeholder_text = "Input password...";
        fail_text = "$PAMFAIL";
        dots_spacing = 0.3;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
      label = [
        { monitor = ""; text = "$TIME"; font_size = 90; font_family = "$font"; position = "-30, 0"; halign = "right"; valign = "top"; }
        { monitor = ""; text = "cmd[update:60000] date +\"%A, %d %B %Y\""; font_size = 25; font_family = "$font"; position = "-30, -150"; halign = "right"; valign = "top"; }
      ];
    };
  };

  # Scripts
  home.file.".config/hypr/scripts/cliphist-rofi-image.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      tmp_dir="/tmp/cliphist"
      rm -rf "$tmp_dir"

      # handle optional first arg (escaped for Nix)
      if [[ -n "''${1-}" ]]; then
          cliphist decode <<<"''${1-}" | wl-copy
          exit
      fi

      mkdir -p "$tmp_dir"

      prog="$(cat <<'EOF'
/^[0-9]+ \s<meta http-equiv=/ { next }
match($0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\t | cliphist decode >" TMPDIR "/" grp[1] "." grp[3])
    print $0"\0icon\x1f" TMPDIR "/" grp[1] "." grp[3]
    next
}
1
EOF
)"

      cliphist list | gawk -v TMPDIR="''${tmp_dir}" "''${prog}"
    '';
  };

  home.file.".config/hypr/scripts/set_wallpaper.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      WALLPAPER="/home/prathamk/Pictures/wallpapers/2.jpg"

      if ! pgrep -x "swww-daemon" >/dev/null; then
        swww-daemon &
        sleep 1
      fi

      swww img "$WALLPAPER" --transition-type any --transition-fps 60 --transition-duration 1
    '';
  };
}
