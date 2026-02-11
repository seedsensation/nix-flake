{ inputs, pkgs, ... }:
{
  services.foundryvtt = {
    enable = true;
    hostname = "biggest-baby";
    minifyStaticFiles = true;
    proxyPort = 443;
    proxySSL = true;
    upnp = true;

    #dataDir = "/home/mercury/.local/share/FoundryVTT/";

    package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12;
  };
}
