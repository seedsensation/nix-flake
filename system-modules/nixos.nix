{
  pkgs,
  inputs,
  config,
  ...
}:
let
  package-groups = import ../packages.nix { inherit pkgs config inputs; };
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
  };
  pkgs-legacy = import inputs.nixpkgs-legacy {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  users.mutableUsers = true;
  services.flatpak = {
    enable = true;
    packages = [
      "com.spotify.Client"
    ];
  };

  users.users.mercury = {
    isNormalUser = true;
    name = "mercury";
    home = "/home/mercury";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    packages = with package-groups; desktop-software ++ kde-stuff ++ nixos-scripts;
  };
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    defaultSession = "sway";
    sddm = {
      enable = true;
      #wayland.enable = true;
      theme = "sddm-personal";
      #package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [
        qt5compat
        qtdeclarative
        qtsvg
      ];
      #wayland.compositor = "kwin";
    };
  };

  #xdg.portal = {
  #  xdgOpenUsePortal = true;
  #  enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-wlr
  #    pkgs.kdePackages.xdg-desktop-portal-kde
  #  ];
  #};

  #services.displayManager.ly = {
  #  enable = true;
  #  package = pkgs.ly;
  #  settings = {
  #    animation = "gameoflife";
  #    #auto_login_user = "mercury";
  #    #auto_login_session = "hyprland";
  #    #default_input = "login";
  #  };
  #};

  #nix.settings = {
  #  substituters = ["https://hyprland.cachix.org"];
  #  trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  #};

  programs = {
    #hyprland = {
    #  enable = true;
    #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    #};

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libxcb
        dbus
        pkg-config
        stdenv.cc.cc
        editline
        alsa-lib
        libGL
        vulkan-loader
        libX11
        libXcursor
        libXext
        libXfixes
        libXi
        libXinerama
        libxkbcommon
        libXrandr
        libXrender
        libdecor
        wayland
        dbus
        dbus.lib
        fontconfig
        fontconfig.lib
      ];
    };

    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
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
  services.xserver.videoDrivers = [ "nvidia" ];
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
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run;
    };
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
      #package = (pkgs-stable.jdk25.overrideAttrs (old: {
      #  enableJavaFX = true;
      #  buildInputs = old.buildInputs ++ [pkgs.makeWrapper];
      #  postFixup = ''
      #    wrapProgram $out/bin/java \
      #    --add-flags "--upgrade-module-path ${pkgs-stable.openjfx25}/lib --module-path ${pkgs.openjfx25}/lib"
      #    wrapProgram $out/bin/javac \
      #    --add-flags "--upgrade-module-path ${pkgs-stable.openjfx25}/lib --module-path ${pkgs.openjfx25}/lib"
      #  '';
      #}));
    };
  };
  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };

  environment.systemPackages =
    let
      application-menu = pkgs.runCommandLocal "xdg-application-menu" { } ''
        mkdir -p $out/etc/xdg/menus/
        ln -s ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out/etc/xdg/menus/applications.menu
      '';
    in
    [
      application-menu
    ];

  system.stateVersion = "25.11";
}
