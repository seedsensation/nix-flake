{
  config,
  pkgs,
  lib,
  ...
}:
let
  window_manager_config =
    # true if sway, false if i3
    wm:
    lib.mkMerge [
      (lib.mkIf (wm == "sway") {

        left = "h";
        down = "j";
        right = "l";
        up = "k";
        input."*".xkb_layout = "gb";
        output.DP-1 = {
          scale = "1.25";
          #bg = "./dotfiles/wallpapers/landscape.png";
        };
      })
      rec {
        modifier = "Mod4";
        menu = if (wm == "sway") then "wmenu-run" else "dmenu_run";
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
        terminal = "kitty";
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

      }
    ];
in
{

  xsession.windowManager.i3 = {
    enable = true;
    config = window_manager_config "i3";
    #config = lib.mkMerge ([
    #  window_manager_defaults
    #  { menu = "dmenu_run"; }

    #  #extraConfig = ''
    #  #  input * {
    #  #      xkb_layout "gb"
    #  #  }
    #  #'';
    #]);
  };

  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    enable = true;
    wrapperFeatures.gtk = true;
    config = window_manager_config "sway";

  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
    };
  };
}
