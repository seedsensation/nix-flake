{ pkgs, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.spotify.Client"
    ];
  };
}
