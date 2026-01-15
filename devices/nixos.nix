{pkgs, inputs, ...}:
let
  package-groups = import ../packages.nix { inherit pkgs; };
in
{
  users.users.mercury = {
    isNormalUser = true;
    name = "mercury";
    home = "/home/mercury";
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    packages = with package-groups; 
    desktop-software ++
    kde-stuff ++
    [
      (pkgs.writeShellScriptBin "rebuild-nixos" "sudo nixos-rebuild switch")

	    (pkgs.writeShellScriptBin "reload-nixos" "sudo nixos-rebuild test")
	    (pkgs.writeShellScriptBin "reload-nixos-trace" "sudo nixos-rebuild test --show-trace")
    ];
  };
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "doom";
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


}
