{pkgs, inputs, ...}:
let
  package-groups = import ./package-groups.nix { inherit pkgs; };
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
      ];
  };
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "doom";
    };
  };


  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;

  networking.networkmanager.enable = true;
  

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  programs.zsh.enable = true;

  programs.firefox.preferences = {
    "browser.startup.homepage" = "https://en.wikipedia.org/wiki/Special:Random";
    "privacy.resistFingerprinting" = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  boot.kernelPackages = pkgs.linuxPackages_latest;


}
