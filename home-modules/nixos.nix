{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.spotify.Client"
    ];
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.sway = {
      default = lib.mkDefault [
        "gtk"
        "wlr"
        "gnome"
      ];
    };
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
