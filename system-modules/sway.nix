{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];

  };

}
