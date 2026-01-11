{ pkgs, ... }:
let
  package-groups = import ../modules/package-groups.nix { inherit pkgs; };
in
{
  users.users.mercury = {
  	name = "seedsensation";
	home = "/Users/seedsensation";
	packages = with package-groups; 
	  user-global ++
	  doom-emacs ++
	  [ 
            (pkgs.writeShellScriptBin "rebuild-darwin" ''
	      sudo darwin-rebuild switch --flake ~/darwin
            '')
          ];
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

  environment.systemPackages = with package-groups;
  	# base packages
	global-utils ++ 
	[ ];

	








}
