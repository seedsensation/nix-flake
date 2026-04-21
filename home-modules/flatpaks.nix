{
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
    config.sway = {
      default = [
        "gtk"
        "wlr"
        "gnome"
      ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

  };

}
