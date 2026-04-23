{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.gnome.gnome-keyring.enable = true;
  hardware.graphics.enable = true;
  security.polkit.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];

  };

}
