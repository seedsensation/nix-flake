{ inputs, pkgs, ... }:
{

  users.users.mercury.extraGroups = ["foundryvtt"];
  
  services.foundryvtt = {
    enable = true;
    hostName = "82.4.129.3";
    minifyStaticFiles = true;
    proxyPort = 30000;
    proxySSL = true;
    world = "heart";
    upnp = true;

    #dataDir = "/home/mercury/.local/share/FoundryVTT/";

    package = inputs.foundryvtt.packages.${pkgs.stdenv.hostPlatform.system}.foundryvtt_12;
  };

  networking.firewall.allowedTCPPorts = [ 30000 ];
}
