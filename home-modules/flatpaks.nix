{ pkgs, config, inputs, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "com.spotify.Client"
    ];
  };

}
