{ inputs, config, pkgs, ... }:
{
  imports = [ 
    inputs.hyprland.homeManagerModules.default
    ../modules/default-home.nix
    ../modules/zsh.nix
    ../modules/hyprland.nix
    ../modules/firefox.nix
    {home.file.".hushlogin".text = "";}

  ];
}
