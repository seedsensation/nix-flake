{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      #desktopManager.plasma6.enable = true;
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
      openFirewall = true;
    };

  };

  environment.systemPackages = [
    pkgs.xclip
  ];
}
