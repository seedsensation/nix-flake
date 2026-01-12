{ config, pkgs, inputs, ... }:
{

  programs.waybar = {
    enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/.wallpapers/landscape.png" ];
      wallpaper = [
        {
          monitor = "DP-1";
          path = "~/.wallpapers/landscape.png";
          fit_mode = "cover";
        }
      ];
      splash = false;
    };
  };

  xdg.configFile."waybar".source = ../.dotfiles/waybar;
  #home.file.".scripts".source = ../scripts;

  home.file.".wallpapers".source = config.lib.file.mkOutOfStoreSymlink ../.wallpapers;
  


  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata Modern Classic";
    size = 16;
  };


  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$menu" = "wofi --show drun";

      monitor = "DP-1,preferred,0x0,auto";

      exec-once = [
        "$terminal"
	      "waybar & hyprpaper"
	      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      animations = {
	      enabled = "yes";
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

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(AC82E9ee) rgba(8F56E1ee) 45deg";
        "col.inactive_border" = "rgba(554e5caa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "hy3";
      };

      # https://wiki.hypr.land/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = "true";
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 8;
          passes = 2;

          vibrancy = 0.1696;
        };
      };

      dwindle.pseudotile = "true";
      dwindle.preserve_split = "true";

      master.new_status = "master";

      misc.force_default_wallpaper = 0;
      misc.disable_hyprland_logo = 1;

      input = {
        kb_layout = "gb";
	      follow_mouse = 1;
	      sensitivity = 0;
	      touchpad.natural_scroll = false;
      };


      bindm = [ 
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+  "
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bind = [

        "$mainMod, return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod SHIFT, space, togglefloating,"
        "$mainMod, space, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, h, hy3:makegroup, h"
        "$mainMod, v, hy3:makegroup, v"
        "$mainMod, a, hy3:changefocus, raise"
        "$mainMod SHIFT, a, hy3:changefocus, lower"
        "$mainMod, escape, hy3:changefocus, bottom"
        "$mainMod, F, fullscreen"
        "$mainMod, P, fullscreenstate, -1, 2"
        "$mainMod, P, pin"
        "$mainMod SHIFT, P, fullscreenstate, 0, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        ", Print, exec, slurp | grim -g - - | wl-copy"
        "$mainMod, t, exec, emacsclient -ca ''"
        "$mainMod, l, exec, hyprlock"
        "SHIFT, Print, exec, flameshot gui"

        "$mainMod, left, hy3:movefocus, l"
        "$mainMod, down, hy3:movefocus, d"
        "$mainMod, up, hy3:movefocus, u"
        "$mainMod, right, hy3:movefocus, r"

        "$mainMod SHIFT, left, hy3:movewindow, l"
        "$mainMod SHIFT, down, hy3:movewindow, d"
        "$mainMod SHIFT, up, hy3:movewindow, u"
        "$mainMod SHIFT, right, hy3:movewindow, r"

        "$mainMod, Period, movewindow, mon:r"
        "$mainMod, Comma, movewindow, mon:l"

        "$mainMod SHIFT, h, exec, killall -SIGUSR1 waybar"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"



      ] ++ (
	      # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists ( builtins.genList (i:
        let ws = i + 1;
        in [
          "$mainMod, code:1${toString i}, workspace, ${toString ws}"
          "$mainMod SHIFT, code:1${toString i}, moveToWorkspace, ${toString ws}"
        ]
        )
        9)
      );

      windowrule = [
        {
	        name = "emacs";
	        opacity = 0.9;
	      }
	      {
	        name = "ghostty";
	        opacity = 0.9;
	      }
      ];

    };
  };

}
