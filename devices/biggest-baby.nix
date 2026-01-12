# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ inputs, config, lib, pkgs, ... }:
let
  package-groups = import ../modules/package-groups.nix { inherit pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
    	../hardware/biggest-baby.nix
    ];

  #programs.git = {
  #  enable = true;
  #  config = {
  #    init.defaultBranch = "main";
  #    url = {
  #      "https://github.com/" = {
  #        insteadOf = [
  #          "gh:"
  #          "github:"
  #        ];
  #      };
  #    };
  #    user.name = "Mercury";
  #    user.email = "m@rcury.com";
  #  };
  #};

  #programs.hyprland = {
  #  enable = true;
  #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  #};

  #programs.zsh.enable = true;

  #programs.firefox.preferences = {
  #    "browser.startup.homepage" = "https://en.wikipedia.org/wiki/Special:Random";
  #    "privacy.resistFingerprinting" = true;
  #  };

  ## Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.timeout = 2;

  ## Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  #networking = {
  #  hostName = "biggest-baby";
  #  interfaces = {
  #    enp4s0.wakeOnLan.enable = true;
  #    wlp0s20f3.useDHCP = true;
  #  };
  #};

  # Configure network connections interactively with nmcli or nmtui.
  #networking.networkmanager.enable = true;

  ## Set your time zone.
  #time.timeZone = "Europe/London";

  ## Link environments for home-manager
  #environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];


  ## Configure network proxy if necessary
  ## networking.proxy.default = "http://user:password@proxy:port/";
  ## networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ## Select internationalisation properties.
  #i18n.defaultLocale = "en_GB.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  #keyMap = "uk";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  ### DISABLED - not using X11
  ## Configure keymap in X11
  #services.xserver.xkb.layout = "us";
  #services.xserver.xkb.options = "eurosign:e,caps:escape";

  ## Enable CUPS to print documents.
  #services.printing.enable = true;

  ## Enable sound.
  #services.pipewire = {
  #  enable = true;
  #  pulse.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.mercury = {
	isNormalUser = true;
	name = "mercury";
	home = "/home/mercury";
	shell = pkgs.zsh;
	extraGroups = [ "wheel" ];
	packages = with package-groups;
	  user-global ++
	  desktop-software ++
	  kde-stuff ++
	  doom-emacs ++
	  [ ];
		
  };

  #programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  #environment.systemPackages = with package-groups; 
  #  global-utils ++
  #  [ ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  #security.pam.services.sshd.googleAuthenticator.enable = true;

  ## Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ];
  #networking.firewall.allowedUDPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  #system.stateVersion = "25.11"; # Did you read the comment?

}

