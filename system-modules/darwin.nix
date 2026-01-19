{ pkgs, ... }:
let
  package-groups = import ../packages.nix { inherit pkgs; };
in
{
  users.users.mercury = {
    name = "seedsensation";
    home = "/Users/seedsensation";
    packages = package-groups.darwin-scripts;
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
