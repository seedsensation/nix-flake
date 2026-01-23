{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma6.enable = true;
    };

    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };
    
  };

  environment.systemPackages = [
    pkgs.xclip
  ];
}
