{ pkgs, ... }:
{
  users.users.mercury = {
    name = "seedsensation";
    home = "/Users/seedsensation";
    packages = 
      [(pkgs.writeShellScriptBin "rebuild-darwin" "sudo darwin-rebuild switch --flake ~/darwin")];
  };

  system.stateVersion = 6;
  system.primaryUser = "seedsensation";

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = { 
    enable = true;
    taps = [];
    brews = [];
    casks = [];
  };
}
