{ pkgs, ... }:
{
  services = {

    #desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
        ];
      };
    };

    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.i3}/bin/i3";
      #defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };

  };

  environment.systemPackages = with pkgs; [
    wayland-utils
    wl-clipboard
    xclip
  ];
}
