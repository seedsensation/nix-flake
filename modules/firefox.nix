{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = ["en-GB"];

    policies = {

      ExtensionSettings = let 
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        "*".installation_mode = "blocked";
        "uBlockOrigin" = {
          install_url = moz "ublock-origin";
          installation_mode = "force_installed";
          updates_disabled = false;
        };
        "SponsorBlock" = {
          install_url = moz "sponsorblock";
          installation_mode = "force_installed";
          updates_disabled = false;
        };

        "3rdparty".Extensions = { 
          "uBlockOrigin".adminSettings = {
            userSettings = rec {
              uiTheme = "dark";
              importedLists = [
                "https:#filters.adtidy.org/extension/ublock/filters/3.txt"
                 "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
              ];

              externalLists = pkgs.lib.concatStringsSep "\n" importedLists;
            };
          };
        };
      };

      profiles.default.search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                { name = "channel"; value = "unstable"; }
                { name = "query";   value = "{searchTerms}"; }
              ];
            }
          ];
          icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
  
        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                { name = "channel"; value = "unstable"; }
                { name = "query";   value = "{searchTerms}"; }
              ];
            }
          ];
          icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };
  
        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }
          ];
          icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nw" ];
        };
      };
    };
  };
}
