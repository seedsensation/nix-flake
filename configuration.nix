## CONFIG FILE FOR GLOBAL SYSTEM CONFIGS
# This should be for config that is shared across every device, including Darwin

{ inputs, config, lib, pkgs, nixpkgs, ... }:
let
  package-groups = import ./packages.nix { inherit pkgs; };
in
{
  
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      url = {
        "https://github.com/" = {
	  insteadOf = [
	    "gh:"
	    "github:"
	  ];
	};
      };
      user.name = "Mercury";
      user.email = "m@rcury.com";
    };
  };

  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "uk";
    useXkbConfig = true; # use xkb.options in tty.
  };

  environment.systemPackages = with package-groups;
    global-utils;

  users.users.mercury.packages = with package-groups;
    emacs-deps ++ user-global;

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = package-groups.emacs;

  };

  fonts.packages = package-groups.fonts;



  # Please do not touch this without considering the ramifications!!!
  system.stateVersion = "25.11";


}
