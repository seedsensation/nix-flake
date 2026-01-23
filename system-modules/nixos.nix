{pkgs, inputs, ...}:
let
  package-groups = import ../packages.nix { inherit pkgs config; };
in
{
  imports = [
    ./remote-desktop.nix
  ];

  users.mutableUsers = true;
  
  users.users.mercury = {
    isNormalUser = true;
    name = "mercury";
    home = "/home/mercury";
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    packages = with package-groups; 
      desktop-software ++
      kde-stuff ++
      nixos-scripts;
  };
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
      auto_login_session = "hyprland";
      default_input = "login";
    };
  };


  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    zsh.enable = true;

    firefox.preferences = {
      "browser.startup.homepage" = "https://en.wikipedia.org/wiki/Special:Random";
      "privacy.resistFingerprinting" = true;
    };
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false;

  networking.networkmanager.enable = true;


  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;



  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  boot.kernelPackages = pkgs.linuxPackages_latest;


  console = {
    font = "Lat2-Terminus16";
    #keyMap = "uk";
    useXkbConfig = true; # use xkb.options in tty.
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  programs = {
    git = {
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
          "https://olympus.ntu.ac.uk/".insteadOf = [ "ol:" ];
        };
        user.name = "Mercury";
        user.email = "m@rcury.com";
      };
    };
    java = {
      enable = true;
      #package = (pkgs.jdk25.override { enableJavaFX = true; });
      package = (pkgs.jdk25.overrideAttrs (old: {
        enableJavaFX = true;
        buildInputs = old.buildInputs ++ [pkgs.makeWrapper];
        postFixup = ''
          wrapProgram $out/bin/java \
          --add-flags "--upgrade-module-path ${pkgs.openjfx25}/lib --module-path ${pkgs.openjfx25}/lib"
          wrapProgram $out/bin/javac \
          --add-flags "--upgrade-module-path ${pkgs.openjfx25}/lib --module-path ${pkgs.openjfx25}/lib"
        '';
      }));
    };
  };
  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };

  system.stateVersion = "25.11";
}
