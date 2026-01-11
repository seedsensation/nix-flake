{ inputs, config, pkgs, ... }:
{
  imports = [ 
    inputs.hyprland.homeManagerModules.default
    ../modules/default-home.nix
    ../modules/zsh.nix
    ../modules/hyprland.nix
  ];
}
