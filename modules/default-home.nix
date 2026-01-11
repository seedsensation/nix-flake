{ config, pkgs, ... }:

{

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.sessionVariables = {
    EDITOR = "emacsclient";
  };
}
