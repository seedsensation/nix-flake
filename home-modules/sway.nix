{
  config,
  pkgs,
  lib,
  ...
}:
rec {

  xsession.windowManager.i3 = {
    enable = true;
    config = lib.mkDefault rec {
      modifier = "Mod4";
      window.titlebar = false;

      colors =
        let
          fg = "#ebdbb2";
          purple = "#8100a0";
          light_purple = "#b16286";
        in
        lib.mkOptionDefault {
          focused = {
            border = "${purple}";
            background = "${purple}";
            text = "${fg}";
            indicator = "${light_purple}";
            childBorder = "${purple}";
          };
        };

      menu = "dmenu_run";

      terminal = "ghostty";
      startup = [
        { command = "firefox"; }
      ];
      keybindings =
        let
          screenshot = "exec grim -g \"$(slurp -d)\" - | wl-copy";
        in
        lib.mkOptionDefault {
          "${modifier}+space" = "exec ${menu}";
          "${modifier}+q" = "kill";
          "${modifier}+z" = "exec emacsclient -ca ''";
          "${modifier}+g" = "bar mode toggle";
          "${modifier}+shift+s" = screenshot;
          "Print" = screenshot;

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume \@DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume \@DEFAULT_SINK@ -5%";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPause" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioStop" = "exec playerctl stop";

        };

      #extraConfig = ''
      #  input * {
      #      xkb_layout "gb"
      #  }
      #'';
    };
  };

  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    enable = true;
    wrapperFeatures.gtk = true;
    config = lib.mkMerge ([
      xsession.windowManager.i3.config
      {

        left = "h";
        down = "j";
        right = "l";
        up = "k";
        input."*".xkb_layout = "gb";
        output.DP-1 = {
          scale = "1.25";
          #bg = "./dotfiles/wallpapers/landscape.png";
        };
        menu = "wmenu-run";
      }
    ]);

  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
    };
  };
}
